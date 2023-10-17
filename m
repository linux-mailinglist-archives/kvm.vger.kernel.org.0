Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A307CC7B6
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 17:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343644AbjJQPos (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 11:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjJQPop (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 11:44:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C8495
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 08:44:43 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39HFiBV6018759;
        Tue, 17 Oct 2023 15:44:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=eXdo8jWPJRumDJbGMlh8BiChSnopKg9v5Ph0z3x1VcM=;
 b=uCUozam8e7WrOGjRqSoJTfddTiJsCtuiCte1agNyvfwmJquK5qoT9Kem6U1JjkWNn5m4
 aL9go6meoYbRcFbEyGDHUMzTgZOj1l5o6lGCaE5PVXh77MAaY/OxetSS1mc2EryfhILN
 SrGDFv8+VxwvDTb083QvCs/zAmq7s7ZiXCb0IrO20w6Ld6DpbVU+Yl9rHCjGB8Q4YwrS
 xNmQ/L2Ib0NI0wbeI+dkc2A7azvZQFoSJXNYfzBewZYhqc64UpkjyJPcfG8FfE8ojZCc
 j09QuZM/5B5+jiiJ7ekKKqKyKQac9lppuWHEVTkeAOlGO8RIZo+vpd8vBqp9jw9c0Mw4 mg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1bnejt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 15:44:20 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39HF8RU4021673;
        Tue, 17 Oct 2023 15:44:20 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg5175uv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 15:44:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b7KhGIblw+qqbFYzSkFV9EBBWGyxwWaSV/Yogm4tJ7LRlY0AbsBOd6R5mabhlIGxwQS1bgnCROq1X0eaQYFbMFwUeYaxBC0Fyo+5rsBQ3Y1AntllMjBxGLjxUpQ5jWSIrGtDboIAppPvpPVFzo2ZUQDzZg/62MXdfZzgG4SPs3PtJZqIWszmRNkBXKjxVw6l+0iBuNZDrxM+bvHAs0gEohjeK1IAMQTBnp8DilDbq5dcMc2kLXLNWC/oF2f87s0XAmwbYajMk7wSVRYWXWbe1aToulJvQ5fqPZ4fudCqnAUfXfVqg7px6pcOaHFiEn61mzHFKTyiyrmUvpjfX8rVDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eXdo8jWPJRumDJbGMlh8BiChSnopKg9v5Ph0z3x1VcM=;
 b=oCvMkOl1aElcUI7zkh0Wkl/Ka+Y4w0SaqZ/UuPw2PFWPkvTs0qUSHuJm+G9760q7244mC3jPxYEoh4ufw6xLxuey5dj7SQ9O8J0+FIuNB0fTxDUGQmW8MqxXyFAIevNdmFBQYK91ke4oEBV+WPpm+pEUegmAwh58L3kiZ0E1x38odnsiKm399bKbtm/V5KX/jGhsTb33P4LWvD6Ytnc2IPLKz8rLJB+FhvoU4rSCfIcMYEvIYmeUxb1HJA+mvw4Ev6+0mJ0o0dxDA58Dh0Z3JQAwKHdJqzXaKXoPAWS+0COoa+eLdRiG4YIPe+0YjpvIWXEySFv5BRX3WWmJMYcLew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eXdo8jWPJRumDJbGMlh8BiChSnopKg9v5Ph0z3x1VcM=;
 b=rIEAdbxjQhUw9pOxH14Hv4jJsso7atcp7Yk7cNTreSQqO5rcUuK9s0mpYeGXPxMbUd5493IAqTIjAjGDjaWaPSi6sSefCkF8Tg/PNPWY4KMFQ84rnM8rdojrejCYV7tKkD+uKbx7/Rm3GeW6SRobMbFWudxfg7tb+P+vs/thdrg=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SA2PR10MB4681.namprd10.prod.outlook.com (2603:10b6:806:fb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Tue, 17 Oct
 2023 15:44:17 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.038; Tue, 17 Oct 2023
 15:44:17 +0000
Message-ID: <7b956358-3d68-4c17-990e-a9ce36101bd8@oracle.com>
Date:   Tue, 17 Oct 2023 16:44:11 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/19] vfio: Move iova_bitmap into iommu core
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>, kvm@vger.kernel.org
References: <1d5b592e-bcb2-4553-b6d8-5043b52a37fa@oracle.com>
 <20231016163457.GV3952@nvidia.com>
 <8a13a2e5-9bc1-4aeb-ad39-657ee95d5a21@oracle.com>
 <20231016180556.GW3952@nvidia.com>
 <97718661-c892-4cbf-b998-cadd393bdf47@oracle.com>
 <20231016182049.GX3952@nvidia.com>
 <6cd99e9b-46d9-47ce-a5d2-d5808b38d946@oracle.com>
 <8b1ff738-6b0d-4095-82a8-206dcaba9ea4@oracle.com>
 <20231017125841.GY3952@nvidia.com>
 <ee2fcf1d-3ab6-426d-a824-7547a98dd1a7@oracle.com>
 <20231017152308.GB3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231017152308.GB3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR08CA0033.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::46) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SA2PR10MB4681:EE_
X-MS-Office365-Filtering-Correlation-Id: ad9bb6d3-548a-4fe2-47d8-08dbcf27ec0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PSWFnXiXtGN12hwy1jQ952JPqGTcz8RL5AhF30ZuSZL7DfQAPd2+UfnE8oMbP8Uiw0ZW1f9DikRrWNxw39Bqs4EgtTM7GbENWL7zIGPneRREI/xqvU6us1cJo3YktSB9lGEGrF8VnNeUupfU/rKuiV8IcSAvcmzCgV0/KorWOq1zEkrWQC2kfNxcVuVkQ62xemq31aJiNXNL6ngoXcerEnkCuNuBKHoIrz3NXRkLXwRAdXKader3qewFRyuBCum2zWdUJPSbD/Dz1lDqAcbSm3LR0NfDLnGFc2bZaNxwraSEm4TazcDPaFcMTuuAivC5cY0bKHzcsrBmsgZSadRFIW9AMtJePApI0TYcejZ5QX/3f1OZlkedzvtlqewwoyabQPWTJ3ciPmIk/U7KLqrKv2VN0gZi9y2DIc0idkCUSW9c+WS0zlGqOToCw7AosuBzjAnDD+D8XhbJv3f0uWpCL5+uU2j7FVyt+K6FrwJ/6ef6382LrAc4xlQZxirWb711wGTjzzwlG0/9MZq6HVhvrKFf6PDL7Y+Wq9EdustknLUHZ326qyHKoQR9jj/mUw0b5uylURNg1Q/Nt62i2bluSPnx0BsmJZCwaF1BUx5gVmXtBJ4CSh6SHpShXycwWO9ISzcu45p24VOfMIwIhJuuDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(376002)(396003)(346002)(136003)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(26005)(38100700002)(6512007)(2616005)(36756003)(5660300002)(7416002)(54906003)(66946007)(66556008)(6916009)(66476007)(41300700001)(8676002)(8936002)(316002)(4326008)(86362001)(53546011)(31696002)(6506007)(6486002)(478600001)(2906002)(6666004)(83380400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bENzdXk1SVU1RHBhdlZ3LzFaTDFVdUV0bW1kOXVpVkQ2K1BodzBKTXVENkZC?=
 =?utf-8?B?eFlSKy9EYk1jbVdhdlJTUkk5TzhuV2dSeVBkSEFZZHVrN0pDYllMOHlHMWI5?=
 =?utf-8?B?bG0rTCt6UUdjTGRoeHlqTk1RUjhZbjdkM1JCWkdtNkRWeS9YUHkxZTFVS0Ew?=
 =?utf-8?B?YStLRkxxSkRwcDZhZmxsNmhqSHkzL0w0N3lldSs2d0VwMWg2MkdFZ01MWnVE?=
 =?utf-8?B?UHg0MHlrS1dZWGFJaHFUcEdydFJaSnVEeHVBMVU2MkdHR3pSd1FveExxT0w0?=
 =?utf-8?B?ZE51TmRrYlpFTE9nUHVZcVk4aVJKeGcxamQ0cUdxdW1ScVV0SjZNUEZPNkhx?=
 =?utf-8?B?cU5NRDNzcFl0dEJmMXlabXFLZ3lSVlJYSGVkMlEwR2oxSHV5a1lrWlY4VExM?=
 =?utf-8?B?V0pvL010UEptQ0Y0WG9pSGk0RzFGNHJYbk0vNE54RXR0Z1ZEOE5zbjZTNkRt?=
 =?utf-8?B?NG5ZUDhMQVMwc0pnclNFdWFLWTNJcTUxcXJDdkl0NGFCSng2MWtQa2FnNXBQ?=
 =?utf-8?B?enJBSDJUS1BkaG52TnM1MC9CQ1hTNWkwZ04xMFJVWDBObjF2elhCZFpGSFJ0?=
 =?utf-8?B?aEUvYTQ5VTdjdkRtUTM4R21tdGxsa2hkZWtKN215YU5iTFZFQ1Y0MHdOUkYw?=
 =?utf-8?B?eDFxa0RoeVlhMkIyM3N5Ky8zU0FYVWdjQ2p5akYzd1FiMlRRc2FoQWVIcWIx?=
 =?utf-8?B?SkhDY3NnTE9HLzNBeXp0bVdBSG9tbVVoUXJIUmk2M0UvektVMUdWZEZacnR5?=
 =?utf-8?B?bFMyRkdITXBVaEcyd1c3eGNpS3pIRVhPaU52US9RdnYxOUlqOVVjNUhJcW9m?=
 =?utf-8?B?eE1FTXVJaUZwRnFKQjQ1S2l2NmttVWFPeDhDTVZSV25rdm1KTkV6ck5nWm1B?=
 =?utf-8?B?MW5PL2hHL0Z4N3pkY013Ty9ZQW1GWUcrWTBPZ2RXZE9aNkswZ0RrMkV4czBl?=
 =?utf-8?B?L3JnNkNTVG1lVGZ5bUJOR0xzSi9kODc0NnFobTlhditicnFDbEtKS2thYTVm?=
 =?utf-8?B?anJNMEdvOURCbEl2Q1F0RzN5N3p0WFF6YmJtWENweEZGY2FicmRBd0J0VU1u?=
 =?utf-8?B?V2JuTTlpY2F3UUxLTXdJeHgrU0FZeGw1bkpFdXNQUFRNZXlRYWFMQktKUHdl?=
 =?utf-8?B?WDhiZjJLNklkbEVrRUVQWTlINTlhSWpNRjJBZW1ITzhNS1JiZGY3c2VTZ2RV?=
 =?utf-8?B?bEI5MXdwTHU1Y3NqbkUyeFI2Sk5lWG5jaXpMajRwZkZaM29VdW5hUmdydlY0?=
 =?utf-8?B?aGJ4SDlxUlZicVZuN0xsbE1UdC9tUEwvQVh5WWR4V2NHSCtZR0dBUkJvUFln?=
 =?utf-8?B?UHBIZ0lFYjM0d0ZUd2RvaWFxVG5GdGtSKzhBV3lrUittVjRNckdmTW42WnRj?=
 =?utf-8?B?YmdHWERiL0xhUTBxZk1EbzllRkJrZ04wZ21vRkh2Vzg4N3QvTDk3dFR4d0pJ?=
 =?utf-8?B?bEw5akNESzlRS0RISjRBT1RTblpMOWpJMlo5a2JIamMvaFFXWWJXd2Q4cWl4?=
 =?utf-8?B?ZVBvVkZ4K21FejNvbzFBck9GVW5pek1KUlpFTUNpeVhVUWdTeGZ2UUQ4bHd4?=
 =?utf-8?B?M25WeUdJRmJ1c0dTYkpFTGt1TXh2YWNCb2Z5WXIxOTFjRzYxbU9ha2sxUTRR?=
 =?utf-8?B?QVR4bFp0MjJRZlo5N3hKMy84Nzg5U044NHBTVm5PMFR6c05Ha1dQYXd4dWJn?=
 =?utf-8?B?VTZhSXE4ZWFLa2gyNEFXVU9rNXUrdEQweCtxOUhTaXRLYnlISittMFNTRFRo?=
 =?utf-8?B?bUkwWnJuclBwTlEwM29yS1dvZ05DT1hpRzBBb0pkNXRhZGE4U3VNVE9Jclls?=
 =?utf-8?B?ZEN1d2theFdIYk83dkMrR3c1aWFHTTZMSkkxUDJ5eklVWHRpOFo3MERjZHJx?=
 =?utf-8?B?NklVMDhMZFNUL3hxWW9ld200S1NudWVzWGNyOUdvU2xoRmJFS3dPVk90RUhl?=
 =?utf-8?B?cWlZcTJRWDVLdDJJT29kazJrajdYVVU3anBmaU1hZS8vNjEzeWV1MkpyNnlL?=
 =?utf-8?B?N0pBWGNLaXl3eVRTKzM1Q0htMW13RlEzN09ud21NTndHeW5UODRQd0o5MlFk?=
 =?utf-8?B?VEhQc0lObHdWaVJ4MWtXVFFhZXBsMXNnYnRxdXV5RFMza1hVRjAraXU1UW1u?=
 =?utf-8?B?aWZUakdMRG1xWkhhREM4QjNTMTNwZ2NSZjlTRk5RaENZL0FtZ1VOcUlCQmpG?=
 =?utf-8?B?MWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?eW1XNjJtRTRnaCtXYmZOME9ob2FWNndSSDFaa1p1NlRZbjhodU9XbjNNai9u?=
 =?utf-8?B?Vm5GZnhCWjlMVjZyMklQZ3hXZW9Pd2pxRjdmdXRqMVh5Z1V3c3lXbmxCWUdj?=
 =?utf-8?B?NkdNQjlHRDQ5ZjAzOFhhMTJGWnpqVGxqU2V6QXp3WWNWcG1pNXRHbVluTGZo?=
 =?utf-8?B?eGs4KzB2UFljakp6dk5PSmhHaVh0WEkvTXQxaE0yNkVSWnlYMUlxelVaSlpS?=
 =?utf-8?B?Q0J6cjliQWVyYXhUclRtN01mRmpncGt6UW5BRkJqL1lIdXliZXpVL1M2QTE4?=
 =?utf-8?B?R2JZNGlYQVU5TlYzTTk5V1FsT1o5M2JHaUpESHJiK0d6VXBnN3Jydlh4aGFy?=
 =?utf-8?B?d3Rra3pjQ0ZxNm5iM2JNVGxpYVBISXlZTk56Qm03WFJWcmFjR3ZwVkc1bXpk?=
 =?utf-8?B?U1poVXcwcHRNbWhEYlJJOVNaZ1V4Q0NKcUswYUJaNDUxdG8yUVQwYTUzYmdh?=
 =?utf-8?B?QUxuUjhSa0owSWVOK0xnTGZDWGpGczczazdBWCs0RWFaNlVPUVg5MjB3dkVw?=
 =?utf-8?B?bVNBWFZNTHl6MjN6RzBlR3hva1AvdVJncmFPdUxTY3h2RmY4V0I4Y293ak5v?=
 =?utf-8?B?UGJOUUhKMVNYSStodXRyTVBuVGJnRTVGTjRpWktBV2pFVzQ4M3lyRWJ2NHA0?=
 =?utf-8?B?L2svMUdZejVrci9PQlFiajQwWWVyL3JEYlNrTzZGaldpUFRrdEZUOGlHdERx?=
 =?utf-8?B?TWJxZ0U3UWFIcGxFa3JKK2xab0NpY2JIaFprL1dSd29wbG1XeGtLaVJFL2lq?=
 =?utf-8?B?QmRCTm1DeE9qV1lwNGluSmtJSnltWUxHem5GNTV5a0lXMmpvNjhaa1NXbTE4?=
 =?utf-8?B?dTFRc1lsSHQveE1xTEsxYk9BTFBTVkRQKy9qdHJIYzdWcVJNVWRSaHppdDhq?=
 =?utf-8?B?bXJpa2ZpTklsYlZlaFA4SFpxQnRxUllJZ2FwUjRoNHdTS2F6NFB0cTFvVk9n?=
 =?utf-8?B?andCSGZmb1RFd0kzbXVscUh5OHlkU1VocVRFK091THhmdHozNjA3NklWc3VK?=
 =?utf-8?B?VCtNaDAxQ2pvT1VOWnZyc0g0amJlRDFObzJqT21COHhCK0xYRDA3eVM3cXNK?=
 =?utf-8?B?NXRlMGNCai9CRFNPZnlUL1NKK3JSTE5QeHc1Q2RmUzRwYzg2TFVQTVE0b3ly?=
 =?utf-8?B?cW1QaTI5WS9QVHl5QTR5djNZRVRYaXIweW1WUzFuVjY1cjBSSlR5ZDYxNzRW?=
 =?utf-8?B?bnpjWDZCM1dDMVNTUllPTWZabkJKZGdHRzNUeUxpNmppUjVqRHRjOFRnTEdp?=
 =?utf-8?B?ZHF2VGRrQ2ZsY3d0V3Z6NDYrQjN4NHdZN01yclV3UkkwOTV3QTF0Qko3NGlF?=
 =?utf-8?B?NDRaY1plelNjME5Ra211d3hiRVpqcDh3bHlhWDE5ZFE0T2xrenBiWXgyKzBG?=
 =?utf-8?B?eHdJUENzMWtObHNkV2tFcTUxRVRHeURlTHd1Mm05d0NneU1zVWlBelZONXVk?=
 =?utf-8?Q?U2sRdhp1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad9bb6d3-548a-4fe2-47d8-08dbcf27ec0e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 15:44:17.5718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IK8M9lq+jey/akIVRkfh57P2G4YNp+NsaWfUSzx5kVit8gDB4mj4URJVci0OeSLVeK1AMRI2yCMRoiECGcFwOWFpKTfqbexJbTLjtycEywA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4681
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-17_03,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170132
X-Proofpoint-GUID: r5BwEvlEJCklmY9a1VtWtRmUNcL9N1Ec
X-Proofpoint-ORIG-GUID: r5BwEvlEJCklmY9a1VtWtRmUNcL9N1Ec
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/10/2023 16:23, Jason Gunthorpe wrote:
> On Tue, Oct 17, 2023 at 04:20:22PM +0100, Joao Martins wrote:
>> On 17/10/2023 13:58, Jason Gunthorpe wrote:
>>> On Mon, Oct 16, 2023 at 07:50:25PM +0100, Joao Martins wrote:
>>>> On 16/10/2023 19:37, Joao Martins wrote:
>>>>> On 16/10/2023 19:20, Jason Gunthorpe wrote:
>>>>>> On Mon, Oct 16, 2023 at 07:15:10PM +0100, Joao Martins wrote:
>>>>>>
>>>>>>> Here's a diff, naturally AMD/Intel kconfigs would get a select IOMMUFD_DRIVER as
>>>>>>> well later in the series
>>>>>>
>>>>>> It looks OK, the IS_ENABLES are probably overkill once you have
>>>>>> changed the .h file, just saves a few code bytes, not sure we care?
>>>>>
>>>>> I can remove them
>>>>
>>>> Additionally, I don't think I can use the symbol namespace for IOMMUFD, as
>>>> iova-bitmap can be build builtin with a module iommufd, otherwise we get into
>>>> errors like this:
>>>>
>>>> ERROR: modpost: module iommufd uses symbol iova_bitmap_for_each from namespace
>>>> IOMMUFD, but does not import it.
>>>> ERROR: modpost: module iommufd uses symbol iova_bitmap_free from namespace
>>>> IOMMUFD, but does not import it.
>>>> ERROR: modpost: module iommufd uses symbol iova_bitmap_alloc from namespace
>>>> IOMMUFD, but does not import it.
>>>
>>> You cannot self-import the namespace? I'm not that familiar with this stuff
>>
>> Neither do I. But self-importing looks to work. An alternative is to have an
>> alternative namespace (e.g. IOMMUFD_DRIVER) in similar fashion to IOMMUFD_INTERNAL.
>>
>> But I fear this patch is already doing too much at the late stage. Are you keen
>> on getting this moved with namespaces right now, or it can be a post-merge cleanup?
> 
> It is our standard, if you want to make two patches in this series that is OK too
> 

This is what I have now (as a separate patch).

It is a little more intrusive as I need to change exist module users
(mlx5-vfio-pci, pds, vfio).

--->8---

From: Joao Martins <joao.m.martins@oracle.com>
Date: Tue, 17 Oct 2023 11:12:28 -0400
Subject: [PATCH v4 03/20] iommufd/iova_bitmap: Move symbols to IOMMUFD namespace

The IOVA bitmap helpers were not using any namespaces, so to adhere with
IOMMUFD symbol export convention, use the IOMMUFD and import in the right
places. This today means to self-import in iommufd/main.c, VFIO and the
vfio-pci drivers that use iova_bitmap_set().

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/iova_bitmap.c | 8 ++++----
 drivers/iommu/iommufd/main.c        | 1 +
 drivers/vfio/pci/mlx5/main.c        | 1 +
 drivers/vfio/pci/pds/pci_drv.c      | 1 +
 drivers/vfio/vfio_main.c            | 1 +
 5 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/iommufd/iova_bitmap.c
b/drivers/iommu/iommufd/iova_bitmap.c
index f54b56388e00..0a92c9eeaf7f 100644
--- a/drivers/iommu/iommufd/iova_bitmap.c
+++ b/drivers/iommu/iommufd/iova_bitmap.c
@@ -268,7 +268,7 @@ struct iova_bitmap *iova_bitmap_alloc(unsigned long iova,
size_t length,
 	iova_bitmap_free(bitmap);
 	return ERR_PTR(rc);
 }
-EXPORT_SYMBOL_GPL(iova_bitmap_alloc);
+EXPORT_SYMBOL_NS_GPL(iova_bitmap_alloc, IOMMUFD);

 /**
  * iova_bitmap_free() - Frees an IOVA bitmap object
@@ -290,7 +290,7 @@ void iova_bitmap_free(struct iova_bitmap *bitmap)

 	kfree(bitmap);
 }
-EXPORT_SYMBOL_GPL(iova_bitmap_free);
+EXPORT_SYMBOL_NS_GPL(iova_bitmap_free, IOMMUFD);

 /*
  * Returns the remaining bitmap indexes from mapped_total_index to process for
@@ -389,7 +389,7 @@ int iova_bitmap_for_each(struct iova_bitmap *bitmap, void
*opaque,

 	return ret;
 }
-EXPORT_SYMBOL_GPL(iova_bitmap_for_each);
+EXPORT_SYMBOL_NS_GPL(iova_bitmap_for_each, IOMMUFD);

 /**
  * iova_bitmap_set() - Records an IOVA range in bitmap
@@ -423,4 +423,4 @@ void iova_bitmap_set(struct iova_bitmap *bitmap,
 		cur_bit += nbits;
 	} while (cur_bit <= last_bit);
 }
-EXPORT_SYMBOL_GPL(iova_bitmap_set);
+EXPORT_SYMBOL_NS_GPL(iova_bitmap_set, IOMMUFD);
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index e71523cbd0de..9b2c18d7af1e 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -552,5 +552,6 @@ MODULE_ALIAS_MISCDEV(VFIO_MINOR);
 MODULE_ALIAS("devname:vfio/vfio");
 #endif
 MODULE_IMPORT_NS(IOMMUFD_INTERNAL);
+MODULE_IMPORT_NS(IOMMUFD);
 MODULE_DESCRIPTION("I/O Address Space Management for passthrough devices");
 MODULE_LICENSE("GPL");
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 42ec574a8622..5cf2b491d15a 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -1376,6 +1376,7 @@ static struct pci_driver mlx5vf_pci_driver = {

 module_pci_driver(mlx5vf_pci_driver);

+MODULE_IMPORT_NS(IOMMUFD);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Max Gurtovoy <mgurtovoy@nvidia.com>");
 MODULE_AUTHOR("Yishai Hadas <yishaih@nvidia.com>");
diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
index ab4b5958e413..dd8c00c895a2 100644
--- a/drivers/vfio/pci/pds/pci_drv.c
+++ b/drivers/vfio/pci/pds/pci_drv.c
@@ -204,6 +204,7 @@ static struct pci_driver pds_vfio_pci_driver = {

 module_pci_driver(pds_vfio_pci_driver);

+MODULE_IMPORT_NS(IOMMUFD);
 MODULE_DESCRIPTION(PDS_VFIO_DRV_DESCRIPTION);
 MODULE_AUTHOR("Brett Creeley <brett.creeley@amd.com>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 40732e8ed4c6..a96d97da367d 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1693,6 +1693,7 @@ static void __exit vfio_cleanup(void)
 module_init(vfio_init);
 module_exit(vfio_cleanup);

+MODULE_IMPORT_NS(IOMMUFD);
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR(DRIVER_AUTHOR);
--
2.17.2
