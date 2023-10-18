Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 433ED7CEC39
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 01:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbjJRXoG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 19:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjJRXoE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 19:44:04 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBD895
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 16:44:02 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39IIn0mQ011250;
        Wed, 18 Oct 2023 23:43:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=6mGiPvVcrmHJkgQpYzfMHn3kLB2jWJZL8P89/Xjrgbo=;
 b=BOdztd3CAXATG2QHA+gfLKnUrBfrNHbYJCQ1vHtDmqwHY2RedOmpfzCQFL5P0/IMVZP6
 PIBdk5QifbC0IB7vgSRfOnnDOoQNjSX83h9MAmf1mp3x1bS3S8rBYxd7puj6uKNJNC1q
 tcG7kaGwW5LwuG3omK54C7OLw7xEE7xxEualKuOAMTO3hxpOwl/898t0qr5XG8tFdbno
 ZrGOk+BiDxj4pv35Eu+fsJwDN7KcYozl4kSuoN/QeeV0KmPGS/IwwnpfbEgabUOW1h97
 nnsEp7N1jVrtpAtkO20s20Qqhm3ws1NeI5x3bs3qphIeI3IvgMWZISA4aKA8X5HXajcw iw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1cgyd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 23:43:28 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39IL74uD021690;
        Wed, 18 Oct 2023 23:43:27 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg535ms7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 23:43:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gUy2v87NC30LWXS6hgejOpPU/6F+Tq6zW/Qzqnn+tKr2wU+bbIWvagFG8qi6t6HxpIQBW663g8ipWTYa1v+Jeo32mseIMCOJ+XU3FR/ezr3BHKM12TMDmb7XwIFXBJ2Q9+pBdJ7voV1egKqVvoijoHMW4G/o89h88SyLY9fLchkYW/NpVKL4iW9sSgojRMOz54CKS67c0cKF1o9GS8wNvI+sGeztBBk2h/8E541XdCwIsqTrV3jTd6eMYBrsTNb0kLXbWO2Wl50hnsfg9ONGFt7lvd3/83bNQwYnDce8mW45SrVgmxWZ2XpiKfO3zzn6zvNS8z2lm01iDhRkLuPVVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6mGiPvVcrmHJkgQpYzfMHn3kLB2jWJZL8P89/Xjrgbo=;
 b=BUjTFrlo+NYl9erfj6heYYEvgP12n2gR2fU/pSJoEbn9r4nbsMHdDprrDQy2Pox6VtilSeXtxgXq1UbRSQ/MML8opjvoCk1dnLrpiPvCVpOB9l1qzQYXqaWviYRRUEAiSl0Yf4vZu56vSSVWDIFATyQrDBSDXUCPEixReerzZj2CrJjAJThEEwlPZ/FY4pMOxR/0kI+pDk2l66MlBd/2C+YLkdIkiPHY7m6yqvWJcbBHKMMd8R8BrxIOzY6GtMXiQak/2j4r93DvULDZFD/Up02otjrfxkD0X+ib+/Uu04QUbLD6kr1bFAx2id2ELyGV0N97F3isCNqnN4iGlEYtgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mGiPvVcrmHJkgQpYzfMHn3kLB2jWJZL8P89/Xjrgbo=;
 b=By7ckWq2ZRgelBnTwzCQ0hQzP/SPhRtqkiFsHQwAXabOOv6VZMFLTswJxvALIOmYvktSedlFMo8bEN7z0OsDzXj9RA507bfwZ27j3Tr8xzPFWtlfce8rqcO5oa0sO+L3fMwuNtQTw8qVHDXCe5jsWtJUNe4zwCg+aDKqTby2+oU=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DS0PR10MB6029.namprd10.prod.outlook.com (2603:10b6:8:cf::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.23; Wed, 18 Oct
 2023 23:43:25 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.022; Wed, 18 Oct 2023
 23:43:24 +0000
Message-ID: <47f6f1bd-bc06-4efc-a5a7-f76c6b58b61f@oracle.com>
Date:   Thu, 19 Oct 2023 00:43:19 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/18] iommufd: Add IOMMU_HWPT_GET_DIRTY_IOVA
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-8-joao.m.martins@oracle.com>
 <20231018223915.GL3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231018223915.GL3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0054.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:34a::14) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|DS0PR10MB6029:EE_
X-MS-Office365-Filtering-Correlation-Id: 1dc75caf-b80d-4acc-acbc-08dbd034052c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AKqTtMlyRVDBJgbWHCCiShJI94HD2qe9VKVvxHK1eMyC+LhOMK7RTt1VtS/gtuXkd8mshH3vryTGuK/uKL+z+xbJZ3VKoZbvHq2fn+jUk5kEw8Pr/xAWQtP0oK5WkjeZlB35gtEG4wwVqTdWTFcD0fQb5LApzXbeGPgOAkV1bTOfHKy2Qf7N04VB0rulAGlsVjfsfs2mrBArkFpwz/UzxeHe3EUTOyvgVLQ0fy1MFyh/LOyFcfIWY4gWoaEsNAyvnmjSziddVUI4AHZaMz2YVLZlEGIBE0Ym3F2mAOTQ+llPPPMFjjN7Rovn75RauTLxk+wBrCEXl2wGoeO1omCg+JIGCtersgUJDaTjVRaZv0Xi1Ilalp7B0Mf8TlPWj2K5yyvGGBgRzgXdmOQWauG7Ab2CKzhYNIgGvaUW31CAPeO8qUmEdQsS0vfHzTf8wZCtjeYqMp13xw/h7utrGmvenNRipjfcM5h/8d83P3l9ggxc1JsbcyUiiU2P3gjOST/qQPhdZqzQYbXYBAiM4UnpeEWilLy9vV8ahPDhqCSm8G8VaIAIRhM5Pn58zhMM2vgy9GmUZpuSiptSKluJSXXGb49R8nhvs3CiWwMy+xWColI4twr4mmQO5wW+KNvuDNwc8Rpakerpvp7za2vx9MXD71Cz6VweV2jZ+Fx7r9fB/g8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(396003)(376002)(136003)(346002)(230922051799003)(186009)(451199024)(64100799003)(1800799009)(4326008)(478600001)(6486002)(8676002)(8936002)(86362001)(7416002)(53546011)(31696002)(2616005)(2906002)(6506007)(26005)(6666004)(36756003)(41300700001)(38100700002)(6512007)(5660300002)(66946007)(66556008)(54906003)(316002)(6916009)(66476007)(31686004)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVNMR0ErcEZBWm9LRnBkRlVXcDBSWUUrdHBBRFFKT0Z3R2lXbVhuaFFQOWdI?=
 =?utf-8?B?Slgyeis3MXdtNEVWZnlNZUt4YnZLbzRPazlTVTl5TFBUZGl5dksxdXdxTTNj?=
 =?utf-8?B?ZUdneEdVR0ZLdG9iN2VVc1BWc2MrZDdkODQ3VXJwamxscE45Q3dHbU1NNkda?=
 =?utf-8?B?bnFjdWxFQUhNQTFUbVZBMzJMRkI1UkZFVm9laVJmeVA1MzRnL3RHam5HbTJo?=
 =?utf-8?B?Q0czcTNBekY1bnhtQ3doRkQzV0o3N0xMeEFXdnlVRExDdEd2VVV3RUhFYmJ0?=
 =?utf-8?B?ejdRUUI1K0Fvcm9KcHVzOGhFVGo3VWpzYjAzNGtkVVloL0dKUm9DV3ZpMEhV?=
 =?utf-8?B?MDIzb3pZNjJlT0k5Vk9jbHlQVjBPS1AyT1dZeFdtemxvRm1xeXppWTBHU0tK?=
 =?utf-8?B?TVgyUk1lR0NJOFNscFU1bEFvSndhSkduU0Q3a1QzMnhYYStzOERIZDJaNWo2?=
 =?utf-8?B?enlESDhhSHZEbkhrSFBaUjZpQmhsNDROZDQycWtxMTZBYW1RbmM4bk5ZS04y?=
 =?utf-8?B?eDdYMmVrL3NCVW1QOXdjQnAvbmI5cWxjSFJkNTZkdXpGdDY3L3ZLamRaY3Z3?=
 =?utf-8?B?endwME9SRFU4MnQ3RmUrZjdEUXA4cDN6U0ZGWG1CMFlWV3JQN0VqY0p3L3Uv?=
 =?utf-8?B?RHhrNGUydmtZeUZidTVNUkFVNi90d1ZlTG1rU3lFTHZ2SWNmcDRHdWtFWmtC?=
 =?utf-8?B?SzdZbzZtNU5FbEtnTWVSY1lLVUZhZldscU9xajZ6RUxuR3U5STZwU3lwRHA0?=
 =?utf-8?B?ZEdKZWt4WXFnYk1vZUdBZnlGNXJybWVUM2E0aGQrdm44Ymd5eUlmMnAxV29U?=
 =?utf-8?B?VmI5QjBiYmU2aTBUYkhUSW5DYklSdWVIWUFhQ2YxUXNQOXQxSXBUT2ZkRDhn?=
 =?utf-8?B?eUQ0VkM3bGRndVpkVVA1MXptelBja3JxTDZ2TXhhWS9mYjhONDBpMXRlQU5y?=
 =?utf-8?B?aVdsaHQ0UEFYRlNSZUJrQ0VqakhCY3d2ZmhEUVdBMzkzSVhUUDJwbzNlbGxY?=
 =?utf-8?B?ZG04TS80YlVaZGFGU1Y0YnJJOEtwOWs4cnUrNFQ2eFROZ2tvNDgxcDRnbklh?=
 =?utf-8?B?WEd1V3YzbjF5a2ZPNnRLOS80NHlxN2tlNGx6WktKK1JMNlJtYkVVYUhqQmFM?=
 =?utf-8?B?a2UwY3RoS2hOTnZuM0QrdDFnL2VWckM4YndISnZyZjYydG81ZTdIR21lampt?=
 =?utf-8?B?VDIrR0ptdkV4U1A2Q1doWXdvekVxSEtiSUtQYnpBNW9OcnYxaWxvMHZzeWxV?=
 =?utf-8?B?RitMUmNBV2l4NW9zN3JNaGFqQTU4VGdHQXU3Y3V2NXMzeFVweEVRSk1Da3I2?=
 =?utf-8?B?YmRMZnhmVUxvbFB4MDhOMm52NUtlcHFkQzhhMHJrSE93RmJqNUZrSVR6ZXlG?=
 =?utf-8?B?N0RXK01tOCtUMTQwQUhZazJIQXVMaEFSeFNwK0VpbndFenBpN0lOVlBZSWJk?=
 =?utf-8?B?M2ZIOHRNTnp3Sk96QmQ2YXVjSG5URHlRclgyQkJzdllrR3RKbzV1Ylk5N2xU?=
 =?utf-8?B?YWo3Nmdnckw0ZEhwTFVGSVd2aWV0eEQzYWpkYTEvN2lvV3ZSK0d2U1hJRGZ4?=
 =?utf-8?B?UzlneVdaR0tXZEExZmhBNDFHK0x5VzJRUzB2eTNBR1lNWGZ1UHdmODR3UmNM?=
 =?utf-8?B?UTVvOXBDRVRWTVNyWjFMMnZVam9PN2Q3ZmM2M0c5MTB3L2I0M2FCTnR2NGRO?=
 =?utf-8?B?aktpYktVYjFqcXM2Mzd5ZWZpaktVdGl4ODMramxRNXYwd1dkelRJbUYybCtB?=
 =?utf-8?B?MmZMTm5iY2hZYmRoeXhMY0gyS1JtTDRoU2lxWmJZMk53WjB6WVQ0ZWFnNDZ5?=
 =?utf-8?B?b1dickFtK3Eyc0lqZkF5UmZxd29jNzBvbG5oM0ZUMEZybFFFOUpHK285Z05H?=
 =?utf-8?B?ZmdNUUFqdURNL2Z3NEgxcVE2SHJZOWRlakIyc2UzdDBQazdsZEREK216YmtH?=
 =?utf-8?B?YzUzZlZlQ1BWNXZXbUJPT0x1T1VHV3IvdUh4czB5NHBWaS8ycWhVL2dMamp3?=
 =?utf-8?B?eTg5QmVrVGFzbGtHOFNFTTBtb25JV21CL0ZhNmpUVFZwOUdrRVNUR1JRTmdx?=
 =?utf-8?B?Uit3d2FmbXRWd0FXdENmU1JHTG5NWE0zOFBUS3VFamJ2WWovQWZWMGkrdU4y?=
 =?utf-8?B?M29OeXdDVUFCR0JYM1RlbHo3bUVma05IbkpJN0FSQWtGWXVxakR0M2MvZWFi?=
 =?utf-8?B?MFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?cU9INW5VQnUyczdUeWpWMHFiejViU00yL1BYREJKZURpcVV1Y1NTcTR5SnlK?=
 =?utf-8?B?N0x5WjRLZXUxc05wNlhRZlJKUDNGN2RhMFpUeDJFV1BEZE0yS0k0NXJxNDBM?=
 =?utf-8?B?RXkrMUJDNmh0RzlpbDl6ZUZzanpBODVaMUN1bDdjbjB0NjhsM0wvZGJoYWNS?=
 =?utf-8?B?T3FSY3ZKRnc0TE1CY0FGUzNiZ01yRVlLZU0wNUNjalNPWG9sVGRJM3ZPa3da?=
 =?utf-8?B?Z1M0RkFEOXZHWURSdzRKVDJ3K0c0dGlxTlE5RVRJQnp0clRlNkw1MXFxWnBZ?=
 =?utf-8?B?SCs4bFJRZlNCZkVrT2dxbnlRWVkyTDJ4Z2FTYWs5Z2lxL0lSNFA5Y085U21q?=
 =?utf-8?B?NmQyRjVESjBOTHhwZGVHZm5CTXdKeUxFNXJBSVZDbVdCNlQ3dzZlYVZjcWtH?=
 =?utf-8?B?TDQrb2J5WUJ4Mk9oeit0RzN6djIvYisxOFBRMnpHTEJ0QVRIV2g5SW1BejJD?=
 =?utf-8?B?M3JRT3dSMnZoT3JMYWlXLzFibXkzS0NKMHMvSlZiUEtUNzRKdTJIYTArZFpR?=
 =?utf-8?B?TlYxSW1ZamVsckhBUElDUXhqMFpRa3JxM2tiYXVCRDBOeUU5VVgvMFhncTR3?=
 =?utf-8?B?T2JxeDFyTWlLMnljNmpDZmhFQm9uMG1Fd1hXWTRHYk1IV0R5bm9rUlpXK3Qv?=
 =?utf-8?B?V1NrNWp5azhJUXdjQkJjUEdHd0QvNUMwNldkU0pMcmNFcXFKWFYzUFViS3R5?=
 =?utf-8?B?RjNPVWJkcGp4NlhQOEkxZ2x1cXdNOVloYVpqWHc4TVg4ekpvR1FVUXkxSmR0?=
 =?utf-8?B?Tk4rQ1FJWmhKWUZwV3FpeWFCczZUU0RpRFFyVko0aUxJME40djhMZFVyblFl?=
 =?utf-8?B?bzJ3ZC9uaUozaGJBU1JjZWpZZkdHNk8xVGVQSmdnZVJiOXNOdmdwVEFXUG02?=
 =?utf-8?B?VlByVnNhRkZHNWdXdGpHdERlMi9XZTYra25TemlTamxXQm02VnM4YmpwZkVq?=
 =?utf-8?B?UVlXZi8vU2p0RHh0NlBHUTJUS0JuY3JoYURqeUJZN2FiWW5pYmtJc2xtNytx?=
 =?utf-8?B?SU5ySWlaTytualovb1ZwcUxrUm5SVUV6QVk5VzN0bFJmeWFEd3Rsak00STNw?=
 =?utf-8?B?YURRdnJTa25lSVcrdzY4UU9WMjJtZytubHpMekhDeHFWODk4QzN4b3pxajV5?=
 =?utf-8?B?QmxGRnMxZEJaanl2LzJURmxnVHhhNVgzOWhMbnRJWUxWczZvODFzTEdCMkgr?=
 =?utf-8?B?V1d6V2k1dDV6Nk5PRFlySys3TExkZTk4RGMrUjUzRU1ZT25pZldoSW9wMEc4?=
 =?utf-8?B?bjB2VFh6Q294STROcXdpU3YrTjd4YkR3VTNIcy9oM05hODliemcwZWxmaUlF?=
 =?utf-8?B?ZTJzWW8zOFZMS1BnYnkySG9xeHp1dlhVSWhrSncvWTI4MFpOWEV5SkZuR2t3?=
 =?utf-8?B?Tm5NRHhSRG1WTG9Jd1VOakNOZmNqRFlxa0JKYkptdDRaSkJFbTIzcHpxaERB?=
 =?utf-8?Q?tXNFOQki?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dc75caf-b80d-4acc-acbc-08dbd034052c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 23:43:24.9099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ALlGE7Bkt7o4RuLoJA2VBV3Gk/fPmtYfSGwbem9iniJFPVpJRxD/Uhxi8f/6xmFd/pzk861WyZHMfs7kCMdIb6cg9EtkM0EB88wjujgagkA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6029
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-18_18,2023-10-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxlogscore=755
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310180196
X-Proofpoint-ORIG-GUID: vm2escCUvGD-6AfpHczOBtRJbjpep7mJ
X-Proofpoint-GUID: vm2escCUvGD-6AfpHczOBtRJbjpep7mJ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/10/2023 23:39, Jason Gunthorpe wrote:
> On Wed, Oct 18, 2023 at 09:27:04PM +0100, Joao Martins wrote:
> 
>> +int iommufd_check_iova_range(struct iommufd_ioas *ioas,
>> +			     struct iommu_hwpt_get_dirty_iova *bitmap)
>> +{
>> +	unsigned long pgshift, npages;
>> +	size_t iommu_pgsize;
>> +	int rc = -EINVAL;
>> +
>> +	pgshift = __ffs(bitmap->page_size);
>> +	npages = bitmap->length >> pgshift;
> 
> npages = bitmap->length / bitmap->page_size;
> 
> ? (if page_size is a bitmask it is badly named)
> 

It was a way to avoid the divide by zero, but
I can switch to the above, and check for bitmap->page_size
being non-zero. should be less obscure


>> +static int __iommu_read_and_clear_dirty(struct iova_bitmap *bitmap,
>> +					unsigned long iova, size_t length,
>> +					void *opaque)
>> +{
>> +	struct iopt_area *area;
>> +	struct iopt_area_contig_iter iter;
>> +	struct iova_bitmap_fn_arg *arg = opaque;
>> +	struct iommu_domain *domain = arg->domain;
>> +	struct iommu_dirty_bitmap *dirty = arg->dirty;
>> +	const struct iommu_dirty_ops *ops = domain->dirty_ops;
>> +	unsigned long last_iova = iova + length - 1;
>> +	int ret = -EINVAL;
>> +
>> +	iopt_for_each_contig_area(&iter, area, arg->iopt, iova, last_iova) {
>> +		unsigned long last = min(last_iova, iopt_area_last_iova(area));
>> +
>> +		ret = ops->read_and_clear_dirty(domain, iter.cur_iova,
>> +						last - iter.cur_iova + 1,
>> +						0, dirty);
> 
> This seems like a lot of stuff going on with ret..
> 

All to have a single return exit point, given no different cleanup is required.
Thought it was the general best way (when possible)

>> +		if (ret)
> 
> return ret
> 
>> +			break;
>> +	}
>> +
>> +	if (!iopt_area_contig_done(&iter))
>> +		ret = -EINVAL;
> 
> return  -EINVAL
> 
>> +
>> +	return ret;
> 
> return 0;
> 
> And remove the -EINVAL. 

OK

> iopt_area_contig_done() captures the case
> where the iova range is not fully contained by areas, even the case
> where there are no areas.
> 
> But otherwise
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Jason
