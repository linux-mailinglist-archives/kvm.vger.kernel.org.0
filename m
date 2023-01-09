Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F054661BDC
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 02:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233986AbjAIBUo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 20:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbjAIBUj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 20:20:39 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29633262C
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 17:20:38 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 308NTVVp019351;
        Mon, 9 Jan 2023 01:20:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=5AMS8xBXKirSq6qXoJ8h7F8UILrJDRV1ze7czode0K0=;
 b=z0mZT4VckPsE/DszzTAkSCTz9C5TyFou7efN72i45QktTwiCz7FL1ZlgOc8anI/r1Fbp
 myTYV2W9oTnXe4e3J3PHCc2T2vHN3zfd5ZE9PvF1LIt+1XOxFTyOvNOZ4l0/Q/6mcdoI
 jnvQDBL+XXMw6NmQGhAPKMEZT5Fbbapvhjheklnp9+SYFbt2UJ/yFeN7HsTfivt8ZuMk
 CVzcPNkZmCTIppbTZ6omJGnwPgou5uyJhi65+/7bexkdXA1kjGAy1dCNBOly54NkNevb
 k5HtWMP2GAcd37fDfrPcTVG9YVXskVfnEt/Uw7N4zeBostZl/tHLJDRr2XLSVBpJTbp7 IA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n05w0g4a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 01:20:01 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 308JuR17008102;
        Mon, 9 Jan 2023 01:20:00 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mxy69dnmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 01:19:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZFsmLiS86k29RrJYZY0D3ei3+r+spHv2ol44KANj2CliFtZLBzbU7uEDz/8CWyK3Twe8ITws9plI6IEs3zuj3D8+bmn27/OySrifE715OrjxRlpXRw4whXQ4f0e4a2HjkoIP1uElGHZ5axx08fPxLZkTBNM9T+OR14stoiDgStmivRG5P6lUmc04ZEoCzDjbJ+pxO6WmleksEF6KgokSCfaTu2XLsL0Msq1AtLuFqj84vGim7gncWPttWa1B8P+tcyMS6DlO0/ML2pcp3+OUDjy5Zsc3Vq1WBvoyr+ARGWvYgCqsoqJudKfS7At6MqmAVEaO/Rb+YyHFzcDVf+nCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5AMS8xBXKirSq6qXoJ8h7F8UILrJDRV1ze7czode0K0=;
 b=HXq+eNeiqY5XBz04zCR/f2qXQx6p6Q9oU8eDFlHFdYspIfaub5ZiSEJOtSo9PiO78K7YjEw9QMuHvAtmszcPFc7glpQu4cwVdCdjjezJMpv+KC26aHr0DuIFUO7+gW2Xhl3TJ47s8YqyO20psCSBWXNOFoKxIHW+xsBCYW5Ei/XYwcnEPfJT4lFpoiI41Ka4DVW+B/nVMg3Vlv6qtAr5vPs768kJrqi9abaYrL/IhQpAHPjEl/t80UzH9hgZb0k9Vkv6TXX6fEDh5OxywUtz5bx0/QTDjFdv3WFwriJ2A4Tra+lOAeb10kwjUBrfXkdtNNZMWd5wC2o2dLeqHUlctw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5AMS8xBXKirSq6qXoJ8h7F8UILrJDRV1ze7czode0K0=;
 b=Ai6C20Ckw89trLSSJ1feHd7vSZc1k3Z3GpviOQhxe5l+c1yp/X1Cg3b6J1y6wGBgvlEg9RWYp6Tl66SfmU9b5Kn1PUaQYDUm146LTR0ACA9EDP4oIhczZtHhgtHYrLebpFmr1fH9aglFH0/jaJURWJ9Wodhx5AEq5va4kncmFjk=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SJ0PR10MB4751.namprd10.prod.outlook.com (2603:10b6:a03:2db::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.10; Mon, 9 Jan
 2023 01:19:57 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::d868:78cd:33d4:ec7]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::d868:78cd:33d4:ec7%7]) with mapi id 15.20.5944.019; Mon, 9 Jan 2023
 01:19:57 +0000
Message-ID: <eea7b6ba-c0bd-8a1e-b2a8-2f08c954628b@oracle.com>
Date:   Sun, 8 Jan 2023 17:19:50 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 0/2] target/i386/kvm: fix two svm pmu virtualization
 bugs
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, joe.jin@oracle.com,
        likexu@tencent.com, groug@kaod.org, lyan@digitalocean.com
References: <20221202002256.39243-1-dongli.zhang@oracle.com>
 <895f5505-db8c-afa4-bfb1-26ecbe27690a@oracle.com>
Content-Language: en-US
In-Reply-To: <895f5505-db8c-afa4-bfb1-26ecbe27690a@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR13CA0005.namprd13.prod.outlook.com
 (2603:10b6:806:130::10) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|SJ0PR10MB4751:EE_
X-MS-Office365-Filtering-Correlation-Id: c51dec9f-d9cc-49af-6829-08daf1df9eb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NPHWPyDtBFwELhIqdXMqfgDCT+P5NUymPDsl/4H8dXGeINYXLBBMfCTM92Itq3X18ccCx6Mn825BR3YTzm0HPGqGCMtCs0uOlgVKSO3NwMLpzzWK1ZcARdCuEXwt+NCvuRyVJrpjIyE011U3vgVifSoRHLlDMGAhxAorgLR3FHYkLIuMlm9+ow2/rPyud2vEdGvHW05k4kSWA9NZDxd+1J6VYSY2FIbvQQkFEfKeV9tEUIywaOnKAeRbjq2CUgvNOWKJ9+be8LhmSs9QGRiTae3Il5zqMNqjL2NSfHm1dAn8BPFgNJRDRD0xN/B20+3zEZyXYl+sPahJSOE9Ivyjdj0C+RYAFNEVo2yXtNMiywHCIRoex/8Cn/XpNVol8Tx40jsD/kiQgMngKuxj9ClXET2zBuBU0J2UFclgODX2K898HazTtL0X1QXAxHa88REQgYWZjGXFaE9VSg0h6IorUCzcfDY8LCeN3qKN22ZhfeopJdS0ViCdbGYxrg41X2HErDJgfV9IBQ/q6ArjnSbPVsxRG2K2IukbYLarHLx4xwC4UEkYsxIFA53Q/4SZD/vyPzoEQoFWq6EhczJYixpZJXP/SjWsK9jbxB5pcJmYHuXmebF0agfWrVNuDHOydnC3sdNfKFAz4Gm3icOV91j1tHjz3aRcIBURFTUXe15uj50aR04sgkYWNYplncgdVSVLxI6oK0gypCJDJCrced5IvgeEmTNQuyU2QDjrlf+vW5ZzhDn39h5H/KlkMu/MWRQ1DZQngd95Rlt4VV4aBcppCAchmpvE4nYRlW/dZB+kXmg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(39860400002)(366004)(136003)(451199015)(38100700002)(86362001)(66946007)(83380400001)(66556008)(66476007)(4326008)(8676002)(31696002)(41300700001)(316002)(44832011)(2906002)(5660300002)(8936002)(6512007)(2616005)(186003)(966005)(478600001)(6486002)(53546011)(6666004)(6506007)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VGlZR29FSHZoR2NIVVRKd05hZ2dVcThCbkRDVjZLTmNXTEhyWWh6TnBPd1F3?=
 =?utf-8?B?RXFjWGo4Z203WHBaRk54Vk82Z3Jzc0Jqb1JYbCtzNkFpa1lxL1FMSjVMSjFu?=
 =?utf-8?B?MnV1bytPS2Z5OFJ1YVZaUmVHc1NaaWNaSk5Fb2JrTmZlcFBHdVRuRGYyOVNM?=
 =?utf-8?B?OHlYUHdSZHc1c3cxeWJyNFV4andlSGNDQU9OZDB2eGhqMmE1VEtuY0t2bFNI?=
 =?utf-8?B?dUExb0piMDc1ZUpVd3hIUm9rVW80YzI5bTE0WDBaVVdYTy9YM25KT0k0U0Qr?=
 =?utf-8?B?QTJsdzdoUDdXbkg3UTJHRnBmRUFadU8rUGxybXNZa1lQcERPalBKa1lJVlhU?=
 =?utf-8?B?OWJHWE1vL2twZm1uMmtzeExaZ1J5aGRkRitUM2xSYmdFNnEwc0l4OFRuaGh1?=
 =?utf-8?B?SzVsUzFlbjhhWXJMc1Z5SSt2T3VuOWVQbVpJOFF1VytOWWFTK0F2cFoxc1lX?=
 =?utf-8?B?cjBoVXo0aEcyaUQ2VnZNSDdoV2wxU3lIakgyN0h3ZjRrSmoybkFDaG1rWnVD?=
 =?utf-8?B?a0VPWnFQZ24vZmRhcWlCdXJXNE5Wc1F4OExzWVlyZGpxWjh6dDVQMWpCM3FR?=
 =?utf-8?B?VjZ4QkU4S0tDWnpXOTFpdCtaS0F6akpHK0ZBMUhLUnVtdlNwK29ZcnVYSVFm?=
 =?utf-8?B?ZldwYUV6aDBqVVM3WlNWeGdvRVpNOXlUcVYyd1ZTSGNDcDRya1ZuQnJFTnQ4?=
 =?utf-8?B?QlNzemtUQkRVa2ZJWTZ5YU5WK091eUpyWVlkNmQwNzNDVUdvSVdJdWp1V0pj?=
 =?utf-8?B?cVU5cWtjcDZKcDRmZ2MwK2VHTjMySFRJdVN6WGtSWURhb3k4NnVJWXpURlRX?=
 =?utf-8?B?RWNIcXVweGJJVEJLUjV0K1FNV09XRFB6aWNrQjZlOXF5L1hWV1YxeDhYQnRB?=
 =?utf-8?B?a0lqZjl4eG1KbzNSL21MNHl2endEdllPazBuRUpvOHJQTmxvSS9pK2pXbjZI?=
 =?utf-8?B?NmtrcllwamhoMjE5aDQ3cUdzc20ycFZTSlF6N1M5UFN6TE9BbmxDMExIMmpO?=
 =?utf-8?B?OHNQNkpPNWZuWmVyTUR6bUN4NW5WVWl1OGgxbWNTR2hUaUNkV3lRenlGQmJh?=
 =?utf-8?B?MUcrVXJsUFg4bVJ3VTB3bzRHK1hOVE9tOW04SXBVb3VWRnY4OStEYXNvUVNW?=
 =?utf-8?B?aUlxSXp3bTQ2bUNidDNHYmJtblBZbEU4cnRWNndkcWpxSTZHaGRqNVNDRmV0?=
 =?utf-8?B?TXE3eG1lQzFFOE1LSGgwdTJFUkw1QUJFb0VYR2xaUExwRHNqa1lwM3ZBdEE2?=
 =?utf-8?B?S1htUHVHdTkxdWRrK2wrZlhDc1E1d0txNnJWU1FIWW1QMUdiUkdLQTVEeFF4?=
 =?utf-8?B?T2JIUERPYzhOUGt2S0s1N1JtV0hKU0I3dGFIL2dYNER0Uis4ajZ2Rnh3cFdj?=
 =?utf-8?B?eHVJdm91dGxLcGN2d3NUTW92K2dJTkM1UXB3c0k1aEpoWmR2eVBTckMxQlAw?=
 =?utf-8?B?d00yMEI1YUJyMHI2ZnAvUnA3TzJsR0pNOG5RZTVZSUJhMG5QUU9IampIbnd5?=
 =?utf-8?B?blV2SjludHUyNGw4WmdWODRCZ1IyOVVWVEFMZmVJT242Vm5nTCszdnJFSmVZ?=
 =?utf-8?B?NnFtRVZzYVNsaUdwS3JtNkgycE1sWUdQK3I0R0xvSjAvYXJwaFUvT3Vsa3Bn?=
 =?utf-8?B?NUhOYk9JWUhGQXlOSE5zSkk0cGYvVDVHazdLS0pOZmx5TWNoUFdoSlhxdmNp?=
 =?utf-8?B?QW1FRzM1d2pPNTFIYjdrNWp6TTJKTENYUUhqT3NtOVlkM2p0WENMU2NlQS9l?=
 =?utf-8?B?c1NyR3lkTjJRQSs5RlUyN2c0dEtGZjQyeCszTlN6SzB5elBORlJOTU1PNnY0?=
 =?utf-8?B?R2R0cFVBRk1PZEZvb1RNck9USWtIY05kc3VnMSt5bFlTa2M3d3V0dFlCSGhJ?=
 =?utf-8?B?Z2hhYjBsTVo4S3dlVHMxZmloU1VXTlc1aW9pNUFPb0pqRVpPcmhVNGh5ZHpn?=
 =?utf-8?B?dWlzemZlTkFNcHhrbEtYeW83WW0rTWkraXlicmsxbkJIWkNTNWZ2UlZJa2pw?=
 =?utf-8?B?Z21rdzNzM24yYlVWZnF4QWV2b1I3WXpMTUUxTC9VckRhY0VUMnJvZ0dEcm9D?=
 =?utf-8?B?MVJCbEFIdmRCTlUwWWhmZXMwZGZXLzkvTUhiM1JDVTlSSzBYMERveUZ2clRN?=
 =?utf-8?B?aHMzY3NmY0R3bWpmRVQ0aHhvRnkvendOdUtXV3R1dW8rb0J6U3hYQXl3UWhm?=
 =?utf-8?Q?btgXer4j5dXbR4mbHC+1xA4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: DikXP7fXO1nBFQE0iKwXVqM7vOC+plrj+wFsN9w/M5Eg5ef9peTJ6doqHXQCoM3VvYJYGXpDX28IPkW3HOWwaWxTcA40ZIUWfNWikyCYNiwfumaCpHLttjdqTDBLZYts9Ms+NIRLQut2Hiv8igilGOqupOXoHIptqYNJPNm1xcK9mDGcdulBXq6VfsyBqpStxhS1DC6SA/TWW7daBJKgKJSHW32ZwjQEysq0NfcKf2mfRtsds8VgNE+sjt1jvlChZ3ah78PUXePhwA7MtBzqP5+zbYt/9oVGAmuJ3P4fLpS4wNKAonWL+4h53Kh0EEkbKwQkMAMM0TkfLHvfRq0oWbI9jQ+0FuM6NGPIX3EYjJxU+b7wsapinD/uvrwYfvihnRqk20fjtMf53GIWiAb2ZpBxt0EE6EYcZMq8tRbnJFTiMO3jB2aD+W9o+Et10GK+ftLrV9U9e1eZdcDx3+zG7PJaOuACWccDx6xxspfKxlAYnGPmz/5BwB6xVuogEQfxNOVeUJ+FO0YDih8bX5D5+qcQF5E3mm8vFiQFubk7v6cWfPXFe9abnehj0W01CiPdfX7wqbU5SX8Hy7WB52hWo4bwo0kMiTavUCc1rZX98fGX1zRLIRYBJ0GRSz47G0zWxxh9R/Sa0ci538vDLnVFgH7ovg3/KhQGyAdFxA0GR8FsH+Ey3VEE+FWsZgqVrLYosIzFwSk0MCfME+XwmMam6fjB942g4I95hPvDaeyxJKUinad0yUh4y0iognb2unT2DdAlADwJhlyb5HQWkaxt8F9seo5bP62VIbbjglmTI5VAjHjVPQAgpYmzJj7uofIlcaX01DOpJYumz/mIadD9n+QWzyA5eiDQzq01SL3oCYf/3v0dOiWnYL0mFOJLHm6RMP/RkV4Yi9f7NpsV6Yzfs9Px4A0euUkbsaItTtpEQpo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c51dec9f-d9cc-49af-6829-08daf1df9eb0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 01:19:57.0739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8xgc+5bw05F773DRVrYLrj3N3aSYUipul8kzUXX2GTsl3CaR4p6Z3OQL4ol04wFnyQRVl8Yx+D6STxRw3ew5vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4751
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-08_19,2023-01-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090008
X-Proofpoint-GUID: LaiNVy3exgU2PGjXQk0dDwYNsGKebNtm
X-Proofpoint-ORIG-GUID: LaiNVy3exgU2PGjXQk0dDwYNsGKebNtm
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping?

About [PATCH v2 2/2], the bad thing is that the customer will not be able to
notice the issue, that is, the "Broken BIOS detected" in dmesg, immediately.

As a result, the customer VM many panic randomly anytime in the future (once
issue is encountered) if "/proc/sys/kernel/unknown_nmi_panic" is enabled.

Thank you very much!

Dongli Zhang

On 12/19/22 06:45, Dongli Zhang wrote:
> Can I get feedback for this patchset, especially the [PATCH v2 2/2]?
> 
> About the [PATCH v2 2/2], currently the issue impacts the usage of PMUs on AMD
> VM, especially the below case:
> 
> 1. Enable panic on nmi.
> 2. Use perf to monitor the performance of VM. Although without a test, I think
> the nmi watchdog has the same effect.
> 3. A sudden system reset, or a kernel panic (kdump/kexec).
> 4. After reboot, there will be random unknown NMI.
> 5. Unfortunately, the "panic on nmi" may panic the VM randomly at any time.
> 
> Thank you very much!
> 
> Dongli Zhang
> 
> On 12/1/22 16:22, Dongli Zhang wrote:
>> This patchset is to fix two svm pmu virtualization bugs, x86 only.
>>
>> version 1:
>> https://lore.kernel.org/all/20221119122901.2469-1-dongli.zhang@oracle.com/
>>
>> 1. The 1st bug is that "-cpu,-pmu" cannot disable svm pmu virtualization.
>>
>> To use "-cpu EPYC" or "-cpu host,-pmu" cannot disable the pmu
>> virtualization. There is still below at the VM linux side ...
>>
>> [    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.
>>
>> ... although we expect something like below.
>>
>> [    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
>> [    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled
>>
>> The 1st patch has introduced a new x86 only accel/kvm property
>> "pmu-cap-disabled=true" to disable the pmu virtualization via
>> KVM_PMU_CAP_DISABLE.
>>
>> I considered 'KVM_X86_SET_MSR_FILTER' initially before patchset v1.
>> Since both KVM_X86_SET_MSR_FILTER and KVM_PMU_CAP_DISABLE are VM ioctl. I
>> finally used the latter because it is easier to use.
>>
>>
>> 2. The 2nd bug is that un-reclaimed perf events (after QEMU system_reset)
>> at the KVM side may inject random unwanted/unknown NMIs to the VM.
>>
>> The svm pmu registers are not reset during QEMU system_reset.
>>
>> (1). The VM resets (e.g., via QEMU system_reset or VM kdump/kexec) while it
>> is running "perf top". The pmu registers are not disabled gracefully.
>>
>> (2). Although the x86_cpu_reset() resets many registers to zero, the
>> kvm_put_msrs() does not puts AMD pmu registers to KVM side. As a result,
>> some pmu events are still enabled at the KVM side.
>>
>> (3). The KVM pmc_speculative_in_use() always returns true so that the events
>> will not be reclaimed. The kvm_pmc->perf_event is still active.
>>
>> (4). After the reboot, the VM kernel reports below error:
>>
>> [    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS detected, complain to your hardware vendor.
>> [    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR c0010200 is 530076)
>>
>> (5). In a worse case, the active kvm_pmc->perf_event is still able to
>> inject unknown NMIs randomly to the VM kernel.
>>
>> [...] Uhhuh. NMI received for unknown reason 30 on CPU 0.
>>
>> The 2nd patch is to fix the issue by resetting AMD pmu registers as well as
>> Intel registers.
>>
>>
>> This patchset does not cover PerfMonV2, until the below patchset is merged
>> into the KVM side.
>>
>> [PATCH v3 0/8] KVM: x86: Add AMD Guest PerfMonV2 PMU support
>> https://lore.kernel.org/all/20221111102645.82001-1-likexu@tencent.com/
>>
>>
>> Dongli Zhang (2):
>>       target/i386/kvm: introduce 'pmu-cap-disabled' to set KVM_PMU_CAP_DISABLE
>>       target/i386/kvm: get and put AMD pmu registers
>>
>>  accel/kvm/kvm-all.c      |   1 +
>>  include/sysemu/kvm_int.h |   1 +
>>  qemu-options.hx          |   7 +++
>>  target/i386/cpu.h        |   5 ++
>>  target/i386/kvm/kvm.c    | 129 +++++++++++++++++++++++++++++++++++++++++-
>>  5 files changed, 141 insertions(+), 2 deletions(-)
>>
>> Thank you very much!
>>
>> Dongli Zhang
>>
>>
