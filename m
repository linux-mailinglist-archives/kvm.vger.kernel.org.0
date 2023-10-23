Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91A2C7D3F0A
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 20:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbjJWSVr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 14:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjJWSVp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 14:21:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05698E
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 11:21:43 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39NHx1QY027892;
        Mon, 23 Oct 2023 18:21:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=+QQK+c3fthN+8jELn+YsGYK+NkwpNyrz0r1IsHNZLwQ=;
 b=Is6t9XlTI5HcNjoYCTqbkj5ByswM6LVuydKRxJr7cFKtxcw5XXM0cAYNv5RqXOatj1Yi
 jtiT/52cKEFWdFhQHX3m5tnLvb4Znd3qOfXxx4WhDAYXSdSCEfR9x08SAv+mJ3zDIZi6
 5WtLiFZLWXSdVpmobtdXDjXFih8Xt6yvkOGYXSuM/Hre6dvzqpRCVaClrsBzY5971j66
 MDNyVitm8aMxuTi/X6NRD5H7bgNFnYiL/SUoLyK8ryG2Sl3Do713Sz4CurEUXih5s0Yx
 99lMKY0/AokkYAZph/l2zLOwqI8PNntzxpsVSU1mmHzODsyI81G67bbudUqyoqe0hz+F hg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv52durjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 18:21:15 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39NGl0Sv001564;
        Mon, 23 Oct 2023 18:21:15 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tv53atagh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 18:21:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lqj4D0FRnjIrY6DL9TaXX2z/2OeXa9uqYoJHpLskSQAWJErBE7gZWxjPH3YW1qd8a7KoNDWvitKbMkKpzQ069oPzXLXwvXEfD7W+UShASy3iYi9OX6DLno3wi53vQ5M8aMIpJedhYPZdVwHqj4x5g3I9p+E5VWywGMwScTrRsBU1/zCf4qjFMWEYj/H9zgKkAcnOXSUbCXKokxERI/ZRkrAuFXz47Epr1n37sjr8E60j8GlOhMPe4B6L/p0IDSzx5k0tdAH0N0amEP0CxW1G3TyA68WUYmmtAnoaOX/kC6CFz8Xzy4DUILPwEWHH0f4YCxgZS7Any+8lZzmXGN3gig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+QQK+c3fthN+8jELn+YsGYK+NkwpNyrz0r1IsHNZLwQ=;
 b=mI9efO0hU3oqLEcRrRr5KhZLg0eH0bNw0EZDBK2Av61Jfn0azwuJaNj9uIWvCPjADkgHbqZiHfpBI+OE79saVVaKp536Cy0SuVYe/gVlMSXvZLx7SWtUs3Rw/Hsay4LQP+obJMhTmjO1/VgtZB6YAiA24ubFU8+4vUOMaOIWEjH6S5Og59FHvr49hQosJ6Mu09kYGpmvTEe6HwpGp5FnCacazXLTBVjBjMlu7FCOlknUIhqWefK2d/Lg70S4cSpRhM6q+YFdZlF8G1GOvhKaEbMKd1EGrT8GD1P/OLkAovEl+sSfF1XZBDE2L4tm5y+QtOK1Z3S9dfLKjWwL8GvNTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+QQK+c3fthN+8jELn+YsGYK+NkwpNyrz0r1IsHNZLwQ=;
 b=nzluoqNV59bc2OVkYHlf/LyrGeoaOitqzXiv7tD5lLxEpsoNkQhakTsyZ8pjC+DjLT6F0XblyVMknGXuhlV6+frIx0q61JfOee9GSr25jphTphUD4XAYdAdtG9MIa+kCO3U+sLVaPeNmbCTM6iI/VaTTbMglriPQP2/sA2L9Hzs=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SA2PR10MB4731.namprd10.prod.outlook.com (2603:10b6:806:11e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Mon, 23 Oct
 2023 18:21:12 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac%3]) with mapi id 15.20.6907.032; Mon, 23 Oct 2023
 18:21:12 +0000
Message-ID: <f9178725-5706-4d56-b496-5f1bc1c48ef6@oracle.com>
Date:   Mon, 23 Oct 2023 19:21:09 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/18] IOMMUFD Dirty Tracking
Content-Language: en-US
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
 <20231021162321.GK3952@nvidia.com> <ZTXOJGKefAwH70M4@Asurada-Nvidia>
 <4e7c8e8d-f22d-40e8-ad41-1e334bb78496@oracle.com>
 <f6f13ff9-ec92-4759-bd0a-9d17a87509cc@oracle.com>
 <ZTa3n+1WQWRLrhxo@Asurada-Nvidia>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <ZTa3n+1WQWRLrhxo@Asurada-Nvidia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0367.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::19) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SA2PR10MB4731:EE_
X-MS-Office365-Filtering-Correlation-Id: cd582cb1-2cdd-4b01-709b-08dbd3f4d64d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IWCFThFQ5KNUNdUlqeE7meg5TQyEQEetJ8FqgDZVkrN+KAUIRfOYhCzvqe2xtlbDOwxCF6KZ8LrMnxE1yYhVlPtnYsH6D5uG4aJbCl/+/ZBNaylUKeg43X72kttZjd4HfCYPqdB8pLmVacpt0rDEZss77Uccazr4PGaHedVkpDuLMfHXZaXRvVcD3san1QW3VDai6GMQGvJxP3ZNX/7EundVnWt9qanECUunmkYMVJB2ZMQFt4PFz8ZTh4P6a5M+urPGXD94YbRzEkM0kZnFOEv2LfYkNR01V8vtCuzvypRxptynJ/2ozFKxz/4xWDYOWSekZ8MefaBFfb9vucWbvG9ulkaT8e9dCl4cfQb0Gm58sh0NRKZvMTo7G7sIWcbWXEeH0WVy4QY+Y3T3YeCL9ioiNrDd9/gWSSub4RXSkp2mYa59JpFcgjhT2Q7wvw/xl72iKsCY3KQlQiV27qnA/glw9Vr1iZ52VghbqyhUwfBwrRdplxH3tWHufY6r139LQ93xrgBFwIRxp3mvb3PNP8A6ggBhCWo3B7COHUW9/V6k741nWRBdhi4UPdQqxT6O/Iih0HqPf1HERgLA0li7E/QkRYvFwRBIPL0CUB1ssezsfIXy5JKYrlyeI/PHCdiRDxHD4bsz0uFCQTw1IrIJr2OJWGKo9YGFiNKHZOjjUR0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(346002)(136003)(376002)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(86362001)(2906002)(66556008)(2616005)(316002)(66476007)(54906003)(6916009)(66946007)(38100700002)(478600001)(6506007)(53546011)(6486002)(6666004)(6512007)(41300700001)(31696002)(36756003)(5660300002)(7416002)(4326008)(8676002)(8936002)(26005)(31686004)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?alVkK01TNjZMSTljSGc3MTlGd2Jma3VXL3BOMTV6KzluYS82clFqNzJicE5E?=
 =?utf-8?B?dG9RVG4zSWNJOEFZWGpWa1NFRmo1WXlYRndkazNEQVRpL2s5QlRiWStZOFRk?=
 =?utf-8?B?RjZPOEJYNXZLVVdObmVHMXRPUDA3QXBENDc1QUc2aXR2V1NVeTVrSEc2bzlo?=
 =?utf-8?B?bW53bnB5SHRpTm10ckxsWFZtZmhVZ3NzNzMyOVBYcTJuQ1Q4U2tpbWVqMXF3?=
 =?utf-8?B?QS9YNHFNZ2JJcFRVTWJXWEt6ZlB1UkNmK3hBTS9kejBDRWw0K2s1Qm1GKzN4?=
 =?utf-8?B?M1JOem1nYjJhMGxYczFOWGQ4aFBhRTFLZFdERE5rVzFQVWlSek5EeDhldGFN?=
 =?utf-8?B?UVVQSWFzRUM2c0srRXZvem12S05vbjF4RWlpem1SemsxVnQvZlZJTlVlcFBm?=
 =?utf-8?B?ZlFPNlFoQmRuUEEwbS95WkllVGJMQWI0Mk5UVnk1ZG9ab2RJUkVIdDVnU1NJ?=
 =?utf-8?B?Z3RpQ1NQd0U0RnpuMEE4Mk42bjNNMFZneS8vSTVNbHZxczdYVnJBR2dEN1pw?=
 =?utf-8?B?bjh3Z0VaNWkxRlU5TW1IK0JzQ2gyUGxlaFMrVFJnSmRsY3VESENiVklkOGFN?=
 =?utf-8?B?dWxQSTFuaUtUT2t0amR2Nm84YTczT2NuTU8rQjE1RkZSQXQ5WXRCQ3lIOFg0?=
 =?utf-8?B?dTlPdzRYVEl0MjRLOU9IaFYwZGRlWHFjaHZlVTczZXpsZTBnL3ZIVWI1OEpr?=
 =?utf-8?B?MlBHbnk1NlNFRVE2RUZUWHhLNkRBcldsVHFIdXhsOXdWVXUxdDhjakVtUFBU?=
 =?utf-8?B?NDIvRmRueGsrTXR3VXFuaVZRTTNVUUVaaWhETUtIUDEyVG4rOU5HWEkreWhX?=
 =?utf-8?B?RlI4WFczYlRrRmgvcFdJM2xJd1o4blNPNU9qWXY0OHpxR28xUnVTM0VsOUxN?=
 =?utf-8?B?K0ZLaWluRGN4THZHZkI1cWgxQWg2cC9kTGtSZDJ0clVVTklXeTJpbjhoY3Ba?=
 =?utf-8?B?bC9FZlo4TUo0ZzJGRy8zSzcwL3ZVS1d6b3M2WE9YZ0lOWnNPN2FsU09BZDd5?=
 =?utf-8?B?eE9mYnE1U05SSVVCcGxqUUtjVkpDQXRtSEM4VFBsbStDbkFXZ3dQZlZyWlpY?=
 =?utf-8?B?M3lIRk1nenJuWUJWWFdEL1pLYjhUeVNJZk93YVVzSWNUWitLQjhkSzV1c0dM?=
 =?utf-8?B?VjF0SzlaREFxU2I4RDZxbmlibkFkQ1VDdHpFcFNoTDRJQXEwS3JJcXBROGN6?=
 =?utf-8?B?MGlRRVRBN1FVZmZqVDNOZ2NlRm9uRDdxVi8xUGgvSWtHRmgzMFQ0c3dUVkRB?=
 =?utf-8?B?c05zYlFZSzFVRUVjWURBcEtaaFI3TWx3ZWFXZFBLdzNJUHVwd2ZNaEQ0L3JQ?=
 =?utf-8?B?VzNJUXNHVWJkN0hKN2x1ZEtqdTYySzIvVlF2MS9URHVrM1lyNUZUa3RFVVds?=
 =?utf-8?B?dk9wUGRIaGR2MFh2ckJyeGpobW1XeURqdURyYmVUWjFUT0g3OHUrejBxNnZE?=
 =?utf-8?B?THNqbXpXbFBpNWlCN3QwMDRyTkxJVUFoTVBETlFRQktISnF0RWVTSXhUUDN6?=
 =?utf-8?B?eERSQnQ0Y2xUL1dxNW9xWllEdzJrT3ZFSi9IM3hnY2gzcWM5cEtkZk40VVZV?=
 =?utf-8?B?c3U0SlRhL2dUSDJOTGx4dnNUVUV1dFdEdHFMbE9wRmlibmo4d2hrTENLc0NW?=
 =?utf-8?B?QnNzTjlCTEdKZlRzcXY2cDNiWk5JQVczWlRGUG02WWRkZ2hpbTZxK2Q4VGpT?=
 =?utf-8?B?OVJsKzI5d3EreDN5U2RMZjRkb3NQMTJJeVJqZndrM1FqVjVaNVlwY3RZUzhC?=
 =?utf-8?B?VEh5ck5tVWZFQjh1OHBSYlhWc3lZRTJQRElwTHFlMlJzUDFNMjZOSHAweFhj?=
 =?utf-8?B?YnFpNFFza1QvOUxkVWdjemJPcWZVTWhtUFcvTXY3YTZkQlgwYVQ2YjgwN1lz?=
 =?utf-8?B?eUJSKzAwNTk2b2l5TGVSaUVtZWdVN1lwNnJETGNGY1ZsWUwyc0IyQVcvWUNS?=
 =?utf-8?B?SjZ3T3JUWlBTaTRTM056L0ptaHJCYWdxci8zejBQdzB6SDBKRm9SdDV5Misr?=
 =?utf-8?B?dkdZbmlzYmE5WlI5K005cTlJWDI5ZGdyUVV1VG9aUzdSaHFHbVZ6bEhGZmty?=
 =?utf-8?B?VWF0QWZMcG1rU1BPMnE0ZFl0MGMxUHU3VGhXMU9BY2RhVG9NbFhNa2p3bHZB?=
 =?utf-8?B?R1d2UW9paVlvZlB1R0d2MGhHSDNKYjlrakFpK1VpTTM4MnhKa1M1TGF6WEpu?=
 =?utf-8?B?NHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZVp1UVlSSGJkRFdydExVMVFHcG9hSTQ0d2Q0UDkycGI0Qmo0cGwvelZZbmUw?=
 =?utf-8?B?YVRDWW14bkFKa0gyUkh1cnZyL3BsWkszdnFXcmUzajc3S3VCYUM2eC9zTFdj?=
 =?utf-8?B?RmxaU2JBQXA3OWlNVWJVVGJxc3U4aWV5eXVieHhZSlRHT3pjVVNLdmlpSDRJ?=
 =?utf-8?B?RmNWQ3Z5VWRIWTQ2VU9sNlFIVDFIUXNWb3cvTW9CRGlwUnc2R1hiTERPdW12?=
 =?utf-8?B?WVV0eTFvODFVSm1DelhlbmNlbWN3OEY0NjF4UVpiclMzQmc4ajFpNis0RDE2?=
 =?utf-8?B?OTNWK0RWWGtIVmMxZ1crYnpXSEtRZW1VTWZoMmEzY2hRbXJFOThZR1dzQkF5?=
 =?utf-8?B?MUxycXRNQzY5WW01K0hsN3JaTEpwNWFFRWVSbG5FUnl1KzVINWNPUm1QRUE1?=
 =?utf-8?B?RFV6Nlc2T251N2toS1RKYWhIODRKL2U5SWUvRVFRamt3VzhMQzBOZ01WWGpG?=
 =?utf-8?B?YXlHNHkvdkZWNU8zZ2VwZGpZYnFhZG5PWVg5OXEvMlgwUXRoOXRyblZGMHlG?=
 =?utf-8?B?OER0Q1pWNTBTeHBVYVgrKzk5TWF6TjRRY2syZ253a1FObDNSemxjZ3pQdVVL?=
 =?utf-8?B?TnB3UWxzODd0enNRejY3RlR5b3lLTTF3TlI3Vzh6enJmY2NmVkNBYnF1Q1Aw?=
 =?utf-8?B?QWRDbmMzQ3lrYnJraTB5NkhkRHJjMHVOQmlZdjBJS3p4a01vMkdhaEJkQ21s?=
 =?utf-8?B?TVFqOE8xVVlNeUZBN05PVy9rNDF3Q3o5UDg4czh6a1k5RzJwNDA1dHppRCtM?=
 =?utf-8?B?WmprYzVwbE5lZVVpZ3gwR3FUS01hbk9jdUFWZDdOQktFTXVGWkVMUGgvSS9k?=
 =?utf-8?B?cVpVZEVPenVrNUk1WmhJREpKYWozQjRmeU1Zd0w5QklaS3FWUWU2VnViOVAx?=
 =?utf-8?B?UkJNWmFFam1BZjYwSXVldldhcURYMGlESjlMRzVtSUdlMVFISXRZZzB5T3hj?=
 =?utf-8?B?S2pNb3p4M1JvcmtiSTg0N3BLMWlKbTNRektIdG5jNERraFVmK2RhMXVxN1dI?=
 =?utf-8?B?UTNNOElpemhML1JSRElDa2FHVm1JU3hWL2dpSFRRbXRzSkVoOE1LSFUwZzhO?=
 =?utf-8?B?Q25UbUQ2R1FERmFuK2R0QnNSeEhlZnFlb05BNEprZHlLdVlrdHFWbzFaNHE3?=
 =?utf-8?B?eVdEZ0JVVHA3RDR4RWJ1bUxTWUN5czRqV041T0xqcXFyeDU1RzBpeEZmaTdJ?=
 =?utf-8?B?N0puQXhBK0hobGVYQS9iallSVHNZNXR5ZFJTSm5oczR3MmFLaGxIY0FsNVNq?=
 =?utf-8?B?QkdjYU1ZUkNKVjVqNmc5ajlDSFlkRDU0eHp3R1NNSUtPNUFGSWtRVDQ4NjNT?=
 =?utf-8?B?c0NXVWdoajUxanFMYUFudnc0YkNIZG8vS1VZeWNVQ1NWQU5oNkM2N29zVWRO?=
 =?utf-8?B?bEo4MVpsUi91M0E0d2kxejF2Z0FsbXJBVis1MGdVQkx1TnRnbndzT1J6Q0Yr?=
 =?utf-8?Q?tw8mtb9l?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd582cb1-2cdd-4b01-709b-08dbd3f4d64d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 18:21:12.6264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3dAiy6gmVucQbQZa1Q2Uim4AehBlZ8pY8oc94JIcvQ5Mw260ZadTAMcpn+gYbzj/pBtmnQPuQVyda7LyfLfd+ZTORa/avq+ZjHOOq5aslAA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4731
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-23_17,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=727
 adultscore=0 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310230160
X-Proofpoint-ORIG-GUID: 1ZKvOSkJWTCUpUmbVrzsaqUSmS4hGfTP
X-Proofpoint-GUID: 1ZKvOSkJWTCUpUmbVrzsaqUSmS4hGfTP
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/10/2023 19:12, Nicolin Chen wrote:
> On Mon, Oct 23, 2023 at 12:49:55PM +0100, Joao Martins wrote:
>> Here's an example down that avoids the kernel header dependency; imported from
>> the arch-independent non-atomic bitops
>> (include/asm-generic/bitops/generic-non-atomic.h)
>>
>> diff --git a/tools/testing/selftests/iommu/iommufd.c
>> b/tools/testing/selftests/iommu/iommufd.c
>> index 96837369a0aa..026ff9f5c1f3 100644
>> --- a/tools/testing/selftests/iommu/iommufd.c
>> +++ b/tools/testing/selftests/iommu/iommufd.c
>> @@ -12,7 +12,6 @@
>>  static unsigned long HUGEPAGE_SIZE;
>>
>>  #define MOCK_PAGE_SIZE (PAGE_SIZE / 2)
>> -#define BITS_PER_BYTE 8
>>
>>  static unsigned long get_huge_page_size(void)
>>  {
>> diff --git a/tools/testing/selftests/iommu/iommufd_utils.h
>> b/tools/testing/selftests/iommu/iommufd_utils.h
>> index 390563ff7935..6bbcab7fd6ab 100644
>> --- a/tools/testing/selftests/iommu/iommufd_utils.h
>> +++ b/tools/testing/selftests/iommu/iommufd_utils.h
>> @@ -9,8 +9,6 @@
>>  #include <sys/ioctl.h>
>>  #include <stdint.h>
>>  #include <assert.h>
>> -#include <linux/bitmap.h>
>> -#include <linux/bitops.h>
>>
>>  #include "../kselftest_harness.h"
>>  #include "../../../../drivers/iommu/iommufd/iommufd_test.h"
>> @@ -18,6 +16,24 @@
>>  /* Hack to make assertions more readable */
>>  #define _IOMMU_TEST_CMD(x) IOMMU_TEST_CMD
>>
>> +/* Imported from include/asm-generic/bitops/generic-non-atomic.h */
>> +#define BITS_PER_BYTE 8
>> +#define BITS_PER_LONG __BITS_PER_LONG
>> +#define BIT_MASK(nr) (1UL << ((nr) % __BITS_PER_LONG))
>> +#define BIT_WORD(nr) ((nr) / __BITS_PER_LONG)
>> +
>> +static inline void set_bit(unsigned int nr, unsigned long *addr)
> 
> The whole piece could fix the break, except this one. We'd need
> __set_bit instead of set_bit.
>

I changed it set_bit in the caller of course
