Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53893638C30
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 15:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiKYOba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 09:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiKYOb2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 09:31:28 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B382CE3C
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 06:31:27 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2APEUPdX008351;
        Fri, 25 Nov 2022 14:31:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=1LnzZ/SqXBr4lvhL733hi/B2jdcuB2LyXV2bdbxgbbc=;
 b=0jxlPw7vqDCc3T9uSLY6rst6AxhCpMhHnjPDxe2fA/qsc9nRa37pZR52u41zfqyiaFnc
 Xxyg1iammP4NJgSNm5RAbTmYIp+6SreK+M6O8iQuwaAlwOWPXkfjUlMP757BwQVliVeG
 999YLZpZ1acbu0ZDyiH1M8xtLd/dZWDNoTuGkH89GZXkP5G8DLCQLr/zEQEwoi74BBS5
 7wRwDXfEWcysqOk+AwDdOXzh5UF7SOSF1K/FEKV1NRosMZdHmHYKbhWOxGz+abZjr17f
 y3kCicg5tP9UynOwhdzff4UesVL7QG9iGGYqWHj1qBvs+I2Hr2ThRPdMvNVmeoY4iqN7 TQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m1mjj5mjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Nov 2022 14:31:22 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2APCiZii011270;
        Fri, 25 Nov 2022 14:31:20 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkgb0jy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Nov 2022 14:31:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZcrQwWeZ1Y07NqSI4cxBPEm0lpN/1wXAQES5s8BMDKA5qHf7f6CIvGjq+pz5DJajf3/wiuRiQ8bGdCbuo9HnZXJaJ0RPV8ETjaYVXw/M6PphoT943T/6nQqKxQXle7ECvgsbDAHtZ0gtpa2fW0LhUPDUuRL/RvFhmxStB54ROnukwg2rL6P0fUrhcLRKorGv/7cl2hUJFtJI8OiLtkzEsNIqd2TnG77+Gt5/ReRIxFJIlqO+6JJv44RjJmwd+sVQjVrfPHqbHgSQU4ueQq2j6Kk81wmYvm1ylxIQstK3wXzZ8qNPyYW1vGnsT8WOcfK5jpU39dImbYbVGhIUQGx+uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1LnzZ/SqXBr4lvhL733hi/B2jdcuB2LyXV2bdbxgbbc=;
 b=Kras5uboW4JOo1rAjLUFKrM2GW28CLtoB4erON9djmMZepzotvO6O4LkKkRtTzbSd0Qs15ECtH6W35IbNb0IGbC+bT8mEiMGv2Wivs+OPPLnDGBrXWkEpYxG1ECCVi/MR+YuRR3NFaRDPljf6lnNe+Q8kVYhHesAVhicinMX5s0NCohOokZhkkFsBRQNNg8QKmfaZKIZJy5nSennHAesldGJys+4ooiPfeQMht9tdE1WUWxIS3xz0A2ZzdFCWKnU4gOplnW1W3H9qRQVkxsnOKC/QVFuOwXerqhMX1HdfPlDba9IN5+c79mOE5Bb0m7ioeMAH2L3xIJKNnHZ5ocCQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1LnzZ/SqXBr4lvhL733hi/B2jdcuB2LyXV2bdbxgbbc=;
 b=y555dTG7hWWOGNjd89BjT3PKmoEleWRwyKMT5INJFAdFayCkaJa3aVQSI76qgvuUmbtn4vIWsXxfBPNChXX8pandGSsePQm3oOoqjqfvN+O9ssy2VydlCfx3QXnPi91x01pYDzo2FAvgtbJVdxObBe0o5TmM+1hU6p26kMbVTZ8=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by CH0PR10MB5225.namprd10.prod.outlook.com (2603:10b6:610:c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Fri, 25 Nov
 2022 14:31:18 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d5e6:f75a:58a4:2e40]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d5e6:f75a:58a4:2e40%9]) with mapi id 15.20.5857.020; Fri, 25 Nov 2022
 14:31:18 +0000
Message-ID: <295d7cf1-ee02-90e9-b271-f53a9ea85bb8@oracle.com>
Date:   Fri, 25 Nov 2022 14:31:12 +0000
Subject: Re: [PATCH v1 2/2] vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
References: <20221025193114.58695-1-joao.m.martins@oracle.com>
 <20221025193114.58695-3-joao.m.martins@oracle.com>
 <Y3+1/a25zcxNT3He@ziepe.ca> <8914ef49-aad4-1461-1176-6d46190d5cd8@oracle.com>
 <Y4C4ITz7oCFBmjWi@ziepe.ca>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <Y4C4ITz7oCFBmjWi@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3PR09CA0015.eurprd09.prod.outlook.com
 (2603:10a6:102:b7::20) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|CH0PR10MB5225:EE_
X-MS-Office365-Filtering-Correlation-Id: d3b23ca9-2e5b-45c0-62ac-08dacef1b708
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KGq5mtWY0Bx/gb8OmYTHB45uUrOmloKAw31Ha6B5traGFJ7Eqshl6ZQ42MHtze3hDjlLt/Ls78O5AvYuymVKSgayiY1Z/DZ5z6Betd7iqug9D+V309UCWAV9Y/Gx8ZT1tYrdsJxznMKx9ykJMrS6KQrugMsErqpq9aQ/cnnZhbQjsIU5FmMZwTwqZH/BGRws0s2v2I5uGP4RECTUQ/fMwDibogEf2urUgQC/26lLaQ/eG8/w2zTdamYWHI2+dY3wu59uR6sE2dVL/ahZCfm7L4+B2roLcVVvEaFnbQQJlhiGPVHphSCKaY8G9t9p+9QM+wt9928+uCDwdMEoFA1i3q3vBqsqZCMgrHLBsGvZKwlYwPrypBtFeH9J5QSTq3hm582x+V4fqUtNvzrry2KjqQf4v7ygbw4epAYeIBIfORySDfIX2OeJVL6QdVWBQN/A0Zacq1fdFohUtqRpnS4/axT21GpRmQe3UJq6JTD2poC2icas5LXCyIAOMRzFovXSmbwYCiChVYP+/Gyyr7WFCJebj7gSByRHObBJCu5bgOVttJAd/TZYQkIgAfhcCxKT2abhyrSNz1IdF0eFD4fIsJVKOW+bYzwfzG80/x9uI7ovtbffBMkq8GKFEy8LZWcOCczgCLY66yfC3XeCtXkLbTRJT7U9f//PllRqkAO1h+xR3ycKBqg8263vE6jE8k8s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(396003)(39860400002)(346002)(451199015)(36756003)(31686004)(38100700002)(2906002)(41300700001)(83380400001)(31696002)(86362001)(66476007)(66946007)(66556008)(6916009)(8676002)(54906003)(6486002)(6512007)(2616005)(316002)(478600001)(8936002)(5660300002)(53546011)(26005)(186003)(6666004)(4326008)(6506007)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnJJMW9HNHhVR3lub2E4RlhWNUg3Z2RSMHVoR0hsNUtXcnNZay9RZDBuL05R?=
 =?utf-8?B?b05kbUtQTHFBQlV1clBnQjdqemRpNGNxaUs0a0RGM1N6blg2WUI2MklaeFlM?=
 =?utf-8?B?NGJSOVJtZHpacXJiR3JDV3VJajR4c21kT0ZqTkg5Tm1QejgrdFU2aEU4anVv?=
 =?utf-8?B?VHJNWUE1MHVNYXBjSks1bkszTmhtSjZtN0c1bXNubUxlUTVSbUJwbGMxdDJI?=
 =?utf-8?B?VGpFU2N6RHBqM1VNdjhVMWhOVGFoR0phTWZQK20xQXhqZlcrQmtBVXZ5ZEtw?=
 =?utf-8?B?VVhOVmtxRDBOazF6WjBCVkNYKzVWZUliUGtQYmQvY3JoWTJ4WWRjT2M0amo4?=
 =?utf-8?B?YlhKU0wzektBeW1RZ05UMFppYVhmU3ZlM2Q2czRQS3Vlc1E5K3N4QTNnSllS?=
 =?utf-8?B?Nnk2dWxDUlh2a0dtT05aVG1Ba05DMUhUazRTaGlKdkNBb0oycnRiRU5mcExk?=
 =?utf-8?B?OHRJckgxVi9Lc0NFdUQyd2xrUG15dDhIY2FGN01HMHhZN1JFSXVhSnBERWpn?=
 =?utf-8?B?SURNL1d6a28renZhblI1Yks2SFFCbVNhREJCT1NyN1Y1V291WTNYeFQza3gy?=
 =?utf-8?B?eGdjZnEvbWo1QXR1aGhtUVlFMlVPL2c1U0loSG1GVDZMc29HblN0VHJReTMv?=
 =?utf-8?B?Q2xFNGQyenppdEl6WGZtNG5xR0x5b2FoWmdHTU1uSTBTUWpHTUhaS2tGSjJo?=
 =?utf-8?B?Y0VJdHBNSE80RDNZeTZNUEt6MTNCWXQ3YzBTbi9rL0x3VW9XenVhN3diMW4w?=
 =?utf-8?B?S0V0VWgyNkFxakpKOHNNWUsxTWJpUk41cmlWVnBjSFJxMFlyS3hTODllVExU?=
 =?utf-8?B?SFRXVXJrRjU4VmwzUW1GdGllaFZoUDYydldrZUl5MkRPdm1wRXlMMEZwY2Fk?=
 =?utf-8?B?ZDJ3TFJNenVYU3hvNzdJRFR1OUJrOXhFK3E3czVlVlB5RDZESWFXNTdKOGFw?=
 =?utf-8?B?TVJpblAwdU1UajFrckpXbDg3VitmRWt5S01rU3lyZE4wVnNtdGt6UmlzVGxK?=
 =?utf-8?B?d0ZxUk9BWUE0VjhaSUpnbXRNYy9JMGk1NTRsUXhBWFZmYklzcUtkYjUwOHZX?=
 =?utf-8?B?bTdXQTRCdGJOSVd3bVpyNFRFVitVNmVCNkdXSGtPV2JpeWZFL3JEZUdyMHZp?=
 =?utf-8?B?djVpbm9JY3p2UGdlWVQ0V05SeE5OeVNzWUxzWEFaSmRiRFRVY09xU3dvK3pH?=
 =?utf-8?B?bXdsdkxWY1pvVFRWS0xabkNnbHpoK1BxVVZ4Qi84YkFreEZXbWNPSnFwcjZC?=
 =?utf-8?B?dDNZM0srVFU2MkRPc25sRGNhVFlCeUg4TTUzZG54QVN3SlhRQTl2UW5IVXVT?=
 =?utf-8?B?aFdObVdENFI4cGlKc0tQUnJ3V3FYbmRuMXNUcHp1K3liTFEyU3ZLSTFHbWhr?=
 =?utf-8?B?cmNvcGUxUGovN0x0ekROVVEzUXNVTlBXUk1TaUpoWlMvQ1VuLzkwL2FXaTVx?=
 =?utf-8?B?ZlRPVkJPLzUvaCtBRzVRNWY3MnVSandXOWhxL0FuM0tqbzEvOFZlTWNNcklR?=
 =?utf-8?B?UFVBaHJjSEw4RFJuMWFwY1RBK1hwcmJhUTF0aXNJNkZoTU5pck9Tbk5vb3Yw?=
 =?utf-8?B?eld6azJiSm1DaFRxMTNBU2tsOWQzd1czc28rUUNIWUlWZk5rdmx6WGFUdWpZ?=
 =?utf-8?B?YjJ4TzJkTW1OakFWMFpQTC9ZckJjbEdvNzdTVjlON2dPSjdIcHFlTndUZW9w?=
 =?utf-8?B?ZUtkajFwTWZiTWR2cEVPTEpYTHFSMzBiRjFlbUwrTjdER2VhWlZQOFdGTVZu?=
 =?utf-8?B?OEN6UU1DaG5yLytHb3JDSWVzeXE0WlEyVGVRYXZmcU00VUNESEhyVURyN3BS?=
 =?utf-8?B?SXhKV3oxbW1KSUx5OGZjKzJOZDhBNVBLWDY4Vlh6S0hIYjhMM3p6eTFzOWhC?=
 =?utf-8?B?M3NXMk81NWxSUEltQmhJUHJ4NEU2Vy9hNk5tM1lCQXRDVHFYYlEzaWwrRWxD?=
 =?utf-8?B?Z3k2VkR3bGZKQmczR3BCbmFDaHVpdjVtNm8zZTZNRjVHNDdDcGNnUUpQUytB?=
 =?utf-8?B?dUMzT3YwVkk0bFRjejVoK2tzS2pVdHovcHhWRDV3akRmRE13NDQwc29QMzhz?=
 =?utf-8?B?UEVDV2s5V3JyYjEzT29Lb1daZWcvS1RXTHZYdm1zSGIxa3VCNGcxZUNIWHZ5?=
 =?utf-8?B?N0R1WTFvOUxqN3lueU1KbnVvVWVSNWpnK0hGOE1Ub0U5Y0I4V2JWRy9PTEpD?=
 =?utf-8?B?Mnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: apX0TpFF//6i6kRUWWupLNeTeHzrqihZJIJhdwCtWnmfASf8R9NsIOjUjmfqsz0h0JTb9JW32g5kS8AjdxePC8tkGjnsWUtYkOmCY1vWdE+biqRVqjQo7OQGK2aRzS5fAw6SDChqXCNaTatHyFsUs36gp7RDc+gy0OouuqbVGI7Xejzhtjf0KFvNfjZ9RhSWHOBmYD+xwysFpvux4dAaiLT2rXMWUHjrbsRp80dx03d/rF3US6UlLcoKKLbIesn+PHgFHkLAfiRYMjfloU1q5bXjP67TJiK56a5ZPOS2yf6tZYYYaUYGqwLqgC9uqHbp58RlQVlI+BpG6TAeVo/fEi+VvbQtz/RoJUoLXfMDGdMshEpiGxCnvlcqj5uuXfphnSYkUaUZruszewxcAGkzOrKHzn2PrakcWf4SOG+rbYpZoARfFNn3nJI0PH/UO1Hm/YmjBdZHVdtshQbQnq67YY8T/XLbt99sr/WbahmOe+xX3kmiguiNyKLeGuXTuIkecuqylJ4Hispq4ywVjjQKMNGkNf8hPcjwcLej3KrNFX+Md44OWGvdI53p2u9zbkHLdRfny8iEvkhSwQiyeX6X2XedPYK8C5iMNj7sj6Nm6m8B6kT4iihppz1rdqp3UhV0Jw0JieKvJmlxxD2IXq7PDL8B2g14Ln/XRLQikSGtqRYmoMXnX3XbLO8g2SwJHUxwmWjxrZSKt41vEFKGGMphPpi7QPkm/0ss5jPrJUxgdWe5JxzBDoM4RQXm/CeSY0MOhjwLz1evcyFAD6LACC/5JfdUV8p/Y6gtouw6/3vfUMWBW8R+uMRR53viIvAO+90FTzkwZ1+PM/roLIIK59s69skEoTrgDSvfQqEBtkhpk90Uo1gHq1blSlV/gw5BBwqMMTFWU/cZ0Cla3icLUtO3Tw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3b23ca9-2e5b-45c0-62ac-08dacef1b708
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 14:31:18.1754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eFMKX1bsKSgk2riJ4wXeiTBt1CSth8ZmcP9/pw/WKcWCoMHT4LxwigPIVEnaLwiT6yK8kvolxpQLgRFZv4Sane0hlEICFfYRJN2uopMD/T0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5225
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_06,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250113
X-Proofpoint-GUID: NGaqhh2NPd1J4gca1oSlqhVFNcEvQ04F
X-Proofpoint-ORIG-GUID: NGaqhh2NPd1J4gca1oSlqhVFNcEvQ04F
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/11/2022 12:42, Jason Gunthorpe wrote:
> On Fri, Nov 25, 2022 at 10:37:39AM +0000, Joao Martins wrote:
> 
>>> Yes, when we move this to iommufd the test suite should be included,
>>> either as integrated using the mock domain and the selftests or
>>> otherwise.
>>
>> So in iommufd counterpart I have already tests which exercise this. But not as
>> extensive.
> 
> We are getting to the point where we should start posting the iommufd
> dirty tracking stuff. Do you have time to work on it for the next
> cycle? Meaning get it largely sorted out in the next 3 weeks for review?
>

I'll post it for the next cycle -- It has been a bit on crazy on my end this
past month or so.

>>> void iova_bitmap_set(struct iova_bitmap *bitmap,
>>> 		     unsigned long iova, size_t length)
>>> {
>>> 	struct iova_bitmap_map *mapped = &bitmap->mapped;
>>> 	unsigned cur_bit =
>>> 		((iova - mapped->iova) >> mapped->pgshift) + mapped->pgoff * 8;
>>> 	unsigned long last_bit =
>>> 		(((iova + length - 1) - mapped->iova) >> mapped->pgshift) +
>>> 		mapped->pgoff * 8;
>>>
>>> 	do {
>>> 		unsigned int page_idx = cur_bit / BITS_PER_PAGE;
>>> 		unsigned int nbits =
>>> 			min(BITS_PER_PAGE - cur_bit, last_bit - cur_bit + 1);
> 
> min(BITS_PER_PAGE - (cur_bit % BITS_PER_PAGE), ...)
> 

I actually had this already in my changeset :) as the earlier snip wasn't
passing my tests. Plus I need to account for less indexes with pgoff, contrary
to what I said earlier in the remaining() function calculation.

>> Not sure if the vfio tree is a rebasing tree (or not?) and can just send a new
>> version, 
> 
> It isn't, you should just post a new patch on top of Alex's current
> tree "rework iova_bitmap_et to handle all page crossings" and along
> the way revert the first bit

OK -- makes sense. The other fix wasn't incorrect either (as we need to account
for pgoff on the same function), this one though fixes the real issue of
iova_bitmap_set().

Also, I'll add your Signed-off-by+Co-developed-by -- let me know otherwise if I
should not.

	Joao
