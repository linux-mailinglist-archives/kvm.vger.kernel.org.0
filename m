Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D7B5171AE
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 16:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237847AbiEBOjs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 10:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385617AbiEBOje (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 10:39:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6DC12749
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 07:36:01 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242Bq0fe032436;
        Mon, 2 May 2022 14:35:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ce8c/Y7jpsO7KulSqgRl9juJ1Qv6daLcYN1yLk65Lno=;
 b=LOMn/aLJKiSJpHz2vtI2WNTYXHTXoIz2nT0tnNFcO63LYKorQ7BjNFmPRn+25PrWCiNb
 1wx5m6PNnmFJmw3WvEFiUTp6DcBv+zOvdY94toKMTelP9dgSaxDWf/6pnOoV6ZKm78pW
 G+rnoCXgUi3cb1wU6sGmEjsz79qcPx+nhfvm75vS9fBPieF5i1RxeHcxtkW9FRJoxjf/
 kyjVmqR59yk7TBUdcLcnCwEnHtvbcX6TGYGcGFVdxH5jgPN5PuawLhIyyWCiAEXdM7u5
 liETJDi/fCAdF3LL/hWZO8jUj5lSIJiUQsjMUfCDuUn24G100Q8odCzBa6UJjlRypLgq Jw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frw0akad9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 May 2022 14:35:30 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 242EUOix035624;
        Mon, 2 May 2022 14:35:28 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2042.outbound.protection.outlook.com [104.47.73.42])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj82ty0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 May 2022 14:35:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BoGoLQMSZYILG2TZ/czSZ8PPMuBTVk3deAIMwNoCH+tKpIELTcD9EllxHzISsNnEqZnjBelChxZGkIMRpVMXTjv7zMyYQJx3UiH2JK4efw2TRt62JYp/xpJ/obHqQRrX/L8pfbEGnz8moEOa948P9tzWa1Uq15yXojRwYZYRpNJLwNDIQjZt+ftCGFjpAc1HhViZzoArT7aZoRdj9oSZvI/8gwyEZ+uPNtZssPYazBz2Ld21gz+hlxHktAHUpfSMcfE5BgRMrW480qDoCsmJ4IQOLxH9RoPF8q+bSnNtqm0SPz0+pWzPIY1pAKg+xorUVgyeaeTO4lzhvVU+WrTR/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ce8c/Y7jpsO7KulSqgRl9juJ1Qv6daLcYN1yLk65Lno=;
 b=eREkdgLJ66RD9dICniondiktM3epUUjQG4V7wp/AXvGDH75XuifdmAjMBhJglG8mJytVzq0eR2a+fsR7DUuXHO5T+Nv6nIxs3SfTJ92SqsXgrI7faQAsCNb11K2qzjNs88VHt56vcCnfyonMDbRVU6cr3UdAqFFlVfnsc6Yx4seUbylh0xzQZywpHeRWcXijgOB53l49+kRNkUoI4ryaK7D3OCyrMi4Del+w2ABoVzgo2sA197siUO3QNA5c+59nd08ubmroiM75jBbWrcHeo+mzllsm8i+GU9N+nBHLPyUt6/ZlERnOGIxjWGzsF5Wa8CzILfetpNQNPxf2lxIc0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ce8c/Y7jpsO7KulSqgRl9juJ1Qv6daLcYN1yLk65Lno=;
 b=LR9XFr539soAzJvHHI6DFrE64K8p6RMwohnXFHb6WKKYX7qfgjZ9tIG6zZjnffUSk/iWirDAETjq+B27aY8skNNLg/lywnAT8h68drRVpXvfdyod7FquLkwhQeMiMc4bLO5iEv7suulF/iAPf5rOMG74x7qS31ZnoVRbgcKyRjo=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3583.namprd10.prod.outlook.com (2603:10b6:208:113::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Mon, 2 May
 2022 14:35:26 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Mon, 2 May 2022
 14:35:26 +0000
Message-ID: <ed3f17a9-1f31-c105-a82f-986801b8a4f4@oracle.com>
Date:   Mon, 2 May 2022 15:35:17 +0100
Subject: Re: [PATCH RFC 09/10] migration/dirtyrate: Expand dirty_bitmap to be
 tracked separately for devices
Content-Language: en-US
To:     Markus Armbruster <armbru@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Thanos Makatos <thanos.makatos@nutanix.com>,
        "John G . Johnson" <john.g.johnson@oracle.com>, kvm@vger.kernel.org
References: <20220428211351.3897-1-joao.m.martins@oracle.com>
 <20220428211351.3897-10-joao.m.martins@oracle.com>
 <87k0b4ksbk.fsf@pond.sub.org>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <87k0b4ksbk.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0077.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::8) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84eac774-d65d-4fd3-31d3-08da2c48feff
X-MS-TrafficTypeDiagnostic: MN2PR10MB3583:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB358364FD445E5AFC531B1235BBC19@MN2PR10MB3583.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U+yGL6OXh7f+94Mk0eDwodi+8TPlmaPE7gf/8i3oGuRRHN4l31RoWob4ml/JadiM1cnJ75TkwRJGpO7UJR1gTyWKpE2KgEh2nVHlLu8HYNHgtkmdKs1Th7mZJulhwXKZ3VBBiW0VWAdZPZTG1ZKfvh0P68mM9sWt42+sUUPgHnXxKgusAvbKMUE/41XF2ARd4P0lE1owcA27PBegG7GQlnwOSrM/n9rUvZLgDOBN85XAiksKFmqO2OhLnD76OYy36CHONKvzLtmWtJ/FAG5OsPZgJwFI3jfzQfZKJZdJVNGUAQoEUktZ3cxc0Sv0QYTw6OnkriS6+fSsrAIVPQrB22OxZfohunLYKWDSSoJFKABGLb3w/V0PaLDALDr7WHuF668FjYfiwX3j4DSQxE2F84kbzD82GJz3rU1T+zq2bxQcK1xIoZJD9qm49mR9oy34UvE8m91AVQ2wDQ3MFOZuVrAQlMfUa2OYrxcVOlX5eQjOu1Zk91kxlA0dQIPzjnwxo1b9o/6w8VqJc30nsfiCFzvRBpIj2ICDhxOkUS0n/HCrOW8Z5zq9Kl1M+C0dOvJtfLYQy9rH9DhUtT6YNYkM2YtURSvC3ZXeL9UV5MQBb8QKa7fwNB7cNrOzma7KOJAtwmrI9+W0smQY7l6VjAxZxB7shasM8I0Ag7LPnH0p6FwNABx6YCWZMtb44Wd01iOwaPrJMHJFxrLj0q+k2ekDJisfUtanJjC4Pe9Xh+ayx0Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(186003)(53546011)(31696002)(54906003)(6916009)(6506007)(6512007)(26005)(83380400001)(7416002)(508600001)(8676002)(4326008)(316002)(8936002)(66946007)(66556008)(66476007)(5660300002)(36756003)(6486002)(86362001)(2906002)(6666004)(31686004)(38100700002)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K0s2bWYwMmd5YldnOExxTXE1UXBCd0Y2VG8vVHdvd2JPNGNWa1UwMzZNOXlo?=
 =?utf-8?B?MjVRcWJKakxUYlFkR2VOZlcvMVpaZ2cyR242ZWJwWlI1YVJ4VlEzRWtpdmZF?=
 =?utf-8?B?R2l0UXZqTTc1d2JoMUdHYXNaWXQxb0o1VHFVWnlmRG5jcmd3Sktlb01wZDFj?=
 =?utf-8?B?eTNHR1YvTi9vS2tGSkdlV1F6OS9XSzRObG9GK3J5bDY3MjR3enhaM1ZuR0pL?=
 =?utf-8?B?NGYyZFJtOFVWRFVXdXE5N1RoeG9NWjNWZjE2bXBycFNudlJsMm5tcjl5bm1Z?=
 =?utf-8?B?TW13eEI1UTVra0ZCWDRjRFpzQTJLUi8yMm8vTUdZcVdNaVdCMnhNSTV3WjFF?=
 =?utf-8?B?REFEL1NwdUsvcU00bk9DaHNkM2g5a2lJb0pLTzlPT3JZWU9jOTlZQ2V6V25N?=
 =?utf-8?B?VGFFSy9NOThxYlBJMFpQOUc4ZkJ5N0hRci9vZGg4NllNOXVaN0FwdW94THZM?=
 =?utf-8?B?RmptRllqQ3p5QUY3N0Q3WEZRMHZYZTJQYmU4dXgzMlBmejlCVWMra2FwN3NU?=
 =?utf-8?B?Rkt1d1lwcGFDTmxlbmM2eG1jTU1ZaW5kTklsN3YvcFRIUjluS3FBOFdwNVlK?=
 =?utf-8?B?dWxsSzFBZmlKT0FJNHgydjRUd1pUSFJJNVRlVzczMDBjeGVOSWlsUjQ2V2VE?=
 =?utf-8?B?N2Z5bTdIMUNqR0FCOUFZOHZvOEdMUllobGljWHQxM1Z5bG4zbmNCOThmQWNS?=
 =?utf-8?B?U2tPYVllOFg5SmErVGtCTGVTS2hxMnRmaTFqeGhYOHBPa2hzdkFiUTJpeEh6?=
 =?utf-8?B?ZDBhZndIZ0p3bUxjak8vOVNidVdqOE1HazBmNVJJOU9xT1hNL1QxN2NSQTdG?=
 =?utf-8?B?ZWZxMWcyOERuWUxlRDN4aGd5TzVhV0RQNWlhV3NaVUNvckwvdU5ST0l4VENX?=
 =?utf-8?B?aXkybElkVHMvOGRxUTNLcFN0K2NzQWVRMUFJY1JYM0o4L3ZHdEdlM3VKNytJ?=
 =?utf-8?B?NzUvZ24yRlR2MGpiSm1ITFQ5amRzRVRON0lPQ3IvVis1YkRKdHpoVU5nRVdK?=
 =?utf-8?B?eFRuUzNaa3FxcjhkMGJrTjk1Q2RQTW10TkpJMVVRRzMrbzVwWlFXam1yeWZY?=
 =?utf-8?B?VG9sTW5nc1pMY2tBUFNVb0QyMnV0cXlFaVRBbk55L1pjZGZxcFA0SlUya1U1?=
 =?utf-8?B?ZnNhb0ZyN3o5Z01EajdXUks2bnBtbStUcnQzRXEzeWs1QndWTG1MNTBjOUxW?=
 =?utf-8?B?L25VSURSd1NNTTJaYkpBRnlKREdvaWpoVGFSNEk2b1cyUnN3K0p6dGNnZDc5?=
 =?utf-8?B?b09uVEprekJWcXN3VkhuSEIyZmJWMWpnVCtBUjJSaTdHNXZlWWYwQndISmUy?=
 =?utf-8?B?NHQ1bXpHRFU4azRjQ01YVVJweGUyVWUxZ3ZjQ3NRRmVoUGo2K3RxVVQxamE1?=
 =?utf-8?B?T2plT0YxbUZZS1I5bjZva08zNU00VHNLeFpmek1mQ1F2NTBvbTBZT1RhQWZa?=
 =?utf-8?B?Ui9sNlBGcnVyczVEaHozTkxtYWxicCtjc3ZaNmsza0FqQkJIa0UyOHV5bGlr?=
 =?utf-8?B?UVpXcGF2ekJ4L1YzeG9Jb1piUDgvQ3FNamY2c0QwZUxqK2NSWWg1Y1JqQnZY?=
 =?utf-8?B?OWRFWnBhOHhMMkc4Ni93bXdWQlZFTW9TYXJBcDY2MER5Vk5uSHJjTHVRZlNB?=
 =?utf-8?B?Vlkydy9PZHRlcWxFdmdoVjJyRTkrNGVJYUl4RFUyVWMyd0JnN2IzajZ5d3M0?=
 =?utf-8?B?WE00YWw3MXplUmVzWjlBVUR1WmZtQXJZajJtUkx0OW1yUnREODJPemg1TCto?=
 =?utf-8?B?SkZNNHM1WHVyMjZoNytqWmhtQzZBZEpBTktqQkF1V3ZnZzd2b0RySzJabUp2?=
 =?utf-8?B?OFJaL1E4V1luVi9KNkVBaERLM3lTdUZUZ1lySGVhMGlqL3lYY2NZaVpLcHYx?=
 =?utf-8?B?cjh6b05kdlV2TWtxelN6bzdUNEU1RkwxcHBIZTBQUkQwWFBNWnNWRHFXa1U1?=
 =?utf-8?B?dks2UnM2UTRwZkFEQWRoQnVuUytTM1ZiU3hIWHhjVlNxTE84WHhSRnlRRERj?=
 =?utf-8?B?RjA2ZGNxOGNRdEtlRWMvcit6MC96Uk81VEVpUVBEcFkwWm5uZUhWWW51M3Z1?=
 =?utf-8?B?MGVGZk94WS91dDloTXZ6bm9NRFV2eGxLdVJXU1JmMEp0dmxuM0x1bTNlcTF3?=
 =?utf-8?B?TzN2aXJGbG9mQzBmVmdxd3EzMEs0TEZ3b0JOOFE3MVBIMUtTMzMrZzNmWitF?=
 =?utf-8?B?NU5UV29mbVNGaTJER0ZmMlpNLzl1VjFWbEx0SnpBUzZtODk5dldGVlVxbFFr?=
 =?utf-8?B?TDVhLzlaV2JpTTRXcGhaeWR2ZEY2aEZTZWlBdU4zZHNQOFdwbkIxa3ZyeEtp?=
 =?utf-8?B?TElhempvcG5ZaVpGRWdNMFVQZHMzTVBOTEg4Q1NGSWNRTVIwMDFteVo2Qm02?=
 =?utf-8?Q?6w0zKPMEhpCXESws=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84eac774-d65d-4fd3-31d3-08da2c48feff
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 14:35:26.1884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FjZF+vwwZqaTzEmFMkDC3HnIWjuLnu78FxBaV73Lx4sVs4FbJdYYCPeOhC7o4QBxMv4nUiCfJNUeTjjNx30+OhVFGIQDI8TnILIEpvlVXfc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3583
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-02_04:2022-05-02,2022-05-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205020114
X-Proofpoint-GUID: ac6-t8ZGHLZ3zYjZYdO83NlCL6-rb24I
X-Proofpoint-ORIG-GUID: ac6-t8ZGHLZ3zYjZYdO83NlCL6-rb24I
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/2/22 13:54, Markus Armbruster wrote:
> Joao Martins <joao.m.martins@oracle.com> writes:
> 
>> Expand dirtyrate measurer that is accessible via HMP calc_dirty_rate
>> or QMP 'calc-dirty-rate' to receive a @scope argument. The scope
>> then restricts the dirty tracking to be done at devices only,
>> while neither enabling or using the KVM (CPU) dirty tracker.
>> The default stays as is i.e. dirty-ring / dirty-bitmap from KVM.
>>
>> This is useful to test, exercise the IOMMU dirty tracker and observe
>> how much a given device is dirtying memory.
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> 
> [...]
> 
>> diff --git a/qapi/migration.json b/qapi/migration.json
>> index 27d7b281581d..082830c6e771 100644
>> --- a/qapi/migration.json
>> +++ b/qapi/migration.json
>> @@ -1793,6 +1793,19 @@
>>  { 'enum': 'DirtyRateMeasureMode',
>>    'data': ['page-sampling', 'dirty-ring', 'dirty-bitmap'] }
>>  
>> +##
>> +# @DirtyRateScope:
>> +#
>> +# An enumeration of scope of measuring dirtyrate.
> 
> "dirtyrate" is not a word.
> 
Indeed. I will be more verbose rather than using 'dirty rate'.

>> +#
>> +# @dirty-devices: calculate dirtyrate by devices only.
> 
> Please document @all, too.
> 
OK. I probably should have used 'vcpu' and 'devices',
rather than 'all' and 'dirty-devices'

>> +#
>> +# Since: 6.2
>> +#

This should be 7.1.

>> +##
>> +{ 'enum': 'DirtyRateScope',
>> +  'data': ['all', 'dirty-devices'] }
>> +
>>  ##
>>  # @DirtyRateInfo:
>>  #
>> @@ -1827,6 +1840,7 @@
>>             'calc-time': 'int64',
>>             'sample-pages': 'uint64',
>>             'mode': 'DirtyRateMeasureMode',
>> +           'scope': 'DirtyRateScope',
> 
> Please document new member @scope.
> 
OK.
