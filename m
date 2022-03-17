Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7B44DC5EC
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 13:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbiCQMl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 08:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiCQMl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 08:41:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2271D08DD
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 05:40:10 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22HBcLIX006894;
        Thu, 17 Mar 2022 12:39:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=rOW8HeA1aPwfPiAOrEuK55v3KtCDqKsglk0nt8ey3BA=;
 b=BWM39G1i0kD5XSKxODRYZ4jr7IhYUiaJkU2/0Gb0Ol8xIz8+gYOSLBc55TS1/Y0FfEtc
 BjTZmm4ooZaeiwLgRLFYEuhgR+tQdooNzDQtSew3xkAWE3WGzP6BMESTtdqdrDjx7geI
 x1KWScJgsBvozBMHMqfFdvsex+vtsdAOXNpz/czR4uxyRT3JhmJCSP5uSvrZ6rfhl+qN
 QEhvb/aUvWWip3Nhi/hi6t2dTBW/VZHjub5nowUdLFRSBBXAXLljur94g9Lj1jjuunIV
 aZ8RVF4IzDw6xVnKIA7ENqpzVB2/mfjxn+JjJVSiWZsGe+RYmzZiDZlFCTEmO/NP0GUW 8w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et52q15j8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Mar 2022 12:39:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22HCZmPV123792;
        Thu, 17 Mar 2022 12:39:53 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by userp3020.oracle.com with ESMTP id 3et659g77x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Mar 2022 12:39:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fJ5NZg5vBxq4c2S2RwAR2JshgWX/6Nd+Bsvkitl2A0MKBbWFzbRDi8/ViVvYT4G3bsEw8hCdjfAT8RkZmcEKgJ8RI3mja13UIbaltPZJTum8hezMGh/M0BojPbITp+5nsUOdcqj059O6kyASgHMIl44eU/z2Xoy4vIK/78wH4YwbtO3MSO6vnMy5atHqYUKDfyolz/t5l2Xc2x/5wzoMs88L50V/g+5/S46v+GrL8DImje2mMGmLehYxrgbu5vDsCXMRAsuWZayR54BrPQzscKJGoXYF9uhTzMx02esk1QQ41gFmI9arECOxRmVnMRh19kpIcH4JztWbxZoCuCDGow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rOW8HeA1aPwfPiAOrEuK55v3KtCDqKsglk0nt8ey3BA=;
 b=cEzp6fobwqrfOwNT18q/ZQBYJTfY+8EKigdE6F7k1najPENFo7TxOUxSz1u1Rc5w3vS8Pu7tLxBaC08jxTu/q+ULCiCo54NAjA+wQ7DVwmcGkGEWAVj8Ur8lBJmNrjO4WDAXqEzEw/6AJFSz3kIfTUVdES3jhS7iyOWgiIIKKhMMmLWrTfWCbT4DLIf+NK6Hz4aGiJ4cJ3idoAS2qrqp5fnGwbr7garCYcrc6reYxXuc5/PqsAEdUGdV+45BKGyYJWhTh4XCFJa4T7qqLXdT3fg0iLMc/nNmuvOKGPYq3eQqkjZ6vuNW3Klaaju4E4AnU3Z1+2GQNfzclymaXjnWHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rOW8HeA1aPwfPiAOrEuK55v3KtCDqKsglk0nt8ey3BA=;
 b=NFqJd7uprp69/o1f2REDwoYDn6LrzQNktYXQApmMoINxtpaXonDjTQSHA9OLEmFaNvZUFEgrcIQikCzAGblqsp0SwDafEsJbdtYhYmmkjZq5HoGy8exqQpLISaRcdDbx097GIeQ8RymDTqiew/PSd3IKtOVpRa35a8yKa5hejGw=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SA1PR10MB5735.namprd10.prod.outlook.com (2603:10b6:806:23e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Thu, 17 Mar
 2022 12:39:51 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5cee:6897:b292:12d0]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5cee:6897:b292:12d0%7]) with mapi id 15.20.5081.018; Thu, 17 Mar 2022
 12:39:51 +0000
Message-ID: <4e36607d-6339-63f0-39ef-3dbf00d9ec4d@oracle.com>
Date:   Thu, 17 Mar 2022 12:39:44 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
Subject: Re: iommufd dirty page logging overview
To:     Thanos Makatos <thanos.makatos@nutanix.com>
Cc:     John Levon <john.levon@nutanix.com>,
        "john.g.johnson@oracle.com" <john.g.johnson@oracle.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <DM8PR02MB80050C48AF03C8772EB5988F8B119@DM8PR02MB8005.namprd02.prod.outlook.com>
Content-Language: en-US
In-Reply-To: <DM8PR02MB80050C48AF03C8772EB5988F8B119@DM8PR02MB8005.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0093.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::33) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 892b0454-c087-41af-aa2e-08da08133a9c
X-MS-TrafficTypeDiagnostic: SA1PR10MB5735:EE_
X-Microsoft-Antispam-PRVS: <SA1PR10MB57358304C676817DD6E00259BB129@SA1PR10MB5735.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: juLVDXdpq9zjraHZwSIhYHhMJ5VeVCZIqGlDVm2sy5+Vp2GCc9Rsr+hqnL1q3+nZbNqPevz3DrG+pcVLzblkVJ83mFGQuzSVgO33abehYsBw+ZzHlwLqLp4xxPNeQCF2Y71uA/OcPFli2LzCujSJrI7fdwumj73S+y6Xym1cWiSknw19kN88P+TCR+V8gGqihZahlUdLnUO4E+T6BhbHXqVw2NwPlBTmhdpyTeJ8LJqojGpe455j1KCsk5srHpVCqEtVjiQvAmFxxVLvzlas2SVvzyjhzOqEuyQ9DqGfTAach4igR8yRGqG3ehDnYzj0r6Wwklu4gF5rLSAZBNjTwyUNLsnr6Lq6zT4xs/b9w1j9wpWnQb0jqxkCQdpbk1mKux/AzB+7Z/2TU6Tsl3kTwCYdqgthmUsj4dwhz58t6cocUcCn8z5u7ARg4hl2+3nfG1Pkhy215bT//Z0MO6n2ygqIB8qHeZ0CGh9GeAPSdCDF/sFNjt19XtNh9uPrzzUfttNeZuuMDqrO0VWzbHHWve1VaUp7CheuBHrDtvq60Do2nKI8rxh329otjYgovdT249RIz4kpnMp1Av/JsHWPZh2ScBMr6XoM/hD628SyYOFWWSvW9a5Ker5v7KEFThOQdP3r0p68APZqiAFEj0flaDC301bDQL3AaIONtFynWNyq4FF5z+SwsbfQ5jvahobv8DNaNpXPaUEoZPUnUDhCUYHejes/r38I3yCga5PjqSK+D6TOG0Xhpifdn8rrLILLbxC+jTwtbe34TnKTLewNMAqwUG/WCraeO6MHHs5NLlsviiH6Gcr48hchQ5BrPUExDOVzKQPObcJZEThP9mTFa1v372zThS25GJ1KxMpAi/w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(6916009)(296002)(316002)(508600001)(2616005)(6486002)(186003)(6512007)(83380400001)(26005)(53546011)(6506007)(6666004)(2906002)(36756003)(38100700002)(7416002)(66556008)(31686004)(66946007)(66476007)(8676002)(4326008)(86362001)(31696002)(8936002)(5660300002)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WWMzRVFQUUdWR3lleTJGYkJyNm43a0c2eklsZG0zbjYzeFdIeHJORktsNXJs?=
 =?utf-8?B?Z2VyWUdwTUhxOU5UVVJKYXZRSHp4a2VkSkNnZTRPSVBlY2hzUXVsNXhnZHl1?=
 =?utf-8?B?UE5lQ3RkUUZiRytWalRHZzN5RnJjNmNucS9neWozbGFqQkIzdEo0TjMxVjE3?=
 =?utf-8?B?THVzMzhIZjQxTXJlbHRSMmZyNFlDMXFDUkdLSG9nSGNrUHh5SUljLzlodDNs?=
 =?utf-8?B?aXBkTkFjbTl2L0pGOUwwUi9DNHZWeFcvTzJXcHJVMXBMZTFZb0JYM1BJNFI4?=
 =?utf-8?B?MmlxOFlWOHo0eHQ5STg4UGZrMzNjNTNqK2VGOU5wWnMxYVlBa0Q4N1Ywc29W?=
 =?utf-8?B?UXNxRVJja2J4S1dzbFJBQnFRZXdyL2xabFhJVGVvVFIxaEVjQkx4K2FOSWl0?=
 =?utf-8?B?NEVrUjN2ZVVJalI3OTEySGt3TjdnaE9rVGlzNzZ3RDAreTlJK3RCRkJrSGVO?=
 =?utf-8?B?azdsNnRPUm5vT2pjenBhNlZuNGFhSndqOHI2eDc1Zis1MkhwMnBHT3MzWVN2?=
 =?utf-8?B?cVg0MVkxdnA1USs4UEJiUitWNGM3dDBsME9VdUdGc21RUnBYWXpNTnZBUjU2?=
 =?utf-8?B?anhVUDhESVZKL1Q0U1UvbjJISTBRR2RxUjkrT1dxcmxlRDhUTFA4aGZoSUU4?=
 =?utf-8?B?cHozTGVNZWgyTU1mMzZvb2gwaEVSUWVTYzhJanpWbnhQeEF2Wk5tSkw2d3pz?=
 =?utf-8?B?aG10bzZwVEx2YjkxZGVwc04vdENNelJTTThjZ2R3QU5jckhUdVBpRE52Q1FV?=
 =?utf-8?B?cFA4ZitJOXA1dDBlcFpKV0tleG0xMG5OWFpNdGRzL2tQbStrYlJBTHgxMytF?=
 =?utf-8?B?MkhJWC9tSzU3NnkzU2RyYnZ3M2VXQURZMnBMZE9sUmhrc0pmTXNzQzUyUG1w?=
 =?utf-8?B?N3hha2lucTBERjZpYjVNQkNzanczMWFDc0h1NjQrL0p6eWhReFNKdFlROE93?=
 =?utf-8?B?ZXBUNEF1V1hQcmNRYVdLVG53dWk0NzRiVDFMWUhJdjVnRjBOM2RhTUtCNmRM?=
 =?utf-8?B?aEFSMVpmY3VlRkhMZjZuZ0h4Zzk1MnR4UDN2djBVd3hsNVE5eElYUFhhQmUz?=
 =?utf-8?B?YzVSNlNlY1dhZkhVZDBuVGNvSXV6aUdIU2pmTEliZmdoQ2MrQk5NbUR6VGRE?=
 =?utf-8?B?QkRWSzFnTGRnSGpNb1ozQXNBVEZURnlyRVNjbXdRS0ZiQlhsODVnR1pzZWx0?=
 =?utf-8?B?TFZuaytXMVVFT0svMldYTTNGY2tpanFnendJUDNveVRFejVIak5wTUNVZUdJ?=
 =?utf-8?B?RDV1QTZhdHdNSUdEdDlZQ0tLUzE1enhUNkNnVUcydXduVnNGNVNhaUp3Sklk?=
 =?utf-8?B?ck1oL0xnYVhpTFBSeUFWWVB1d25hNEVnUUdQdFlpLys1ZjBrMVBkMVVWVHNh?=
 =?utf-8?B?T1c2eDArby9DdmJ6ME9wTy9PSzFSbldUVUFPNTIyc1lVUjdPd21qMHEwS0Vr?=
 =?utf-8?B?cWU0ZTdiZnkrcVZBM0Zqb3V3UTgxNSsreVhmTFg2dmpRZTBFc25ldWpxM3A1?=
 =?utf-8?B?OU8yQVhuMEZHMlorTDM4UGFDeGx2NVpnczQzWVhqWXZVb3JoT1FyTC9CMWFs?=
 =?utf-8?B?WlgyRCtEQzIySVNJa2libVVsbi9POEl1NHJ1ZWxMMEtTdHZ4MzFmYm9ZeDcv?=
 =?utf-8?B?YTBzVGV3RWpZbmFqdllCeVFXL2Q2NlB3a2phRUdXaFlCdXJkeE9FelpsL3NY?=
 =?utf-8?B?SWdFL0dxblpXSTE3K3FITnlOdzVSSTZ5LzJsbDJHVHByZEM5cE84aTFjSzg0?=
 =?utf-8?B?NWM4Q1hyaTdZUHRYQlZkN0FsK3g0d2xuMXJkTlNmeFJ3WXRRdmlyNkhwdWE1?=
 =?utf-8?B?OUQyV0J6ZGlKd1I4SUNvMTUvcTlWeEd1VUxWRVY2a2p6YlV0WWVRZkJGazVa?=
 =?utf-8?B?dUpHanBSK3VyVlFyYlFiNXA4bU1yQVg2QVpSTzh5YVNDQ0hpcVdzUFhJaHZP?=
 =?utf-8?B?eFI4dUllc0lMUkVNZUw0Y1hISEc2NTlXbG9oSFo0eVlkbEQxSnVXSGZMdzJv?=
 =?utf-8?B?SzdDRWQzb3JnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 892b0454-c087-41af-aa2e-08da08133a9c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2022 12:39:51.4760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VYz2nL1TOxindNgP3VXpS8Fe3OClJQTwohtCOl3UwsiILgWfQYHKuvKvHgYbAII61uwVyYLn9rQ42+nTqdFKOi8Yf24hKAlUq6FqQuPPBoU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5735
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10288 signatures=693715
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203170073
X-Proofpoint-GUID: fS8LrXscXKEZA743AQjwIwHDgoD1b0O-
X-Proofpoint-ORIG-GUID: fS8LrXscXKEZA743AQjwIwHDgoD1b0O-
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/22 23:29, Thanos Makatos wrote:
> We're interested in adopting the new migration v2 interface and the new dirty
> page logging for /dev/iommufd in an out-of-process device emulation protocol
> [1]. Although it's purely userspace, we do want to stay close to the new API(s)
> being proposed for many reasons, mainly to re-use the QEMU implementation. The
> migration-related changes are relatively straightforward, I'm more interested
> in the dirty page logging. I've started reading the relevant email threads and
> my impression so far is that the details are still being decided? I don't see
> any commits related to dirty page logging in Yi's repo
> (https://github.com/luxis1999/iommufd) (at least not in the commit messages). I
> see that Joao has done some work using the existing dirty bitmaps
> (https://github.com/jpemartins/linux/commits/iommufd).

This branch here so far covers current vfio compatibility of iommufd (with an
AMD IOMMU implementation) solely because it was the easiest to start with given
the existing userspace (qemu). There's also a qemu counterpart with the emulated
AMD IOMMU implementation (should you lack the hardware). I'll be updating those branches
as things evolve i.e. once I have an initial version of the iommufd native API and more
IOMMUs support. Now, whether the vfio-compat part remains is TBD.

TBH much how we are discussing on the list -- and that Jason iterated yesterday --
I too don't expect a divergence on the API semantics from current VFIO system IOMMU
tracking. userspace-facing dirty reporting eventually gets a bitmap, with a bit
representing a <page-size>, the bitmap represents a range with a "base" iova and a <size>
(subset of a previously DMA-mapped range) that *matches* the size of the bitmap. And then
you start/stop tracking, read the dirty data and lastly DMA unmaps also fetch the dirty
data (if requested). The device-dirty tracking (via PCI) ought to model the target PF/VF
vendor interface but that is not iommufd.

The new things iommu-wise I expect are more about what the current API doesn't capture,
though, these are somewhat unrelated to the tracking control / reporting itself and more
about the IO page tables mappings i.e. changing domain's <page-size> in-place/dynamically
to increase the granularity of the dirty tracking.

[*] interestingly, arm64 SMMUv3.x seems to have an idea of 'stalling' transactions (not
sure if all kinds are supported) and letting CPU retry them as if the endpoint had just
requested ... without depending on endpoint PRI support.

> Is there a rough idea of
> how the new dirty page logging will look like? Is this already explained in the
> email threads an I missed it?
>
Granted that you came across the repo, I suppose you went through all the threads :)
