Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8F196387A9
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 11:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiKYKh7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 05:37:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiKYKh4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 05:37:56 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DCFA23155
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 02:37:53 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2APATcKP004633;
        Fri, 25 Nov 2022 10:37:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=FcXLKR8baP5jQC66ujBvpyFLtwzGiKE8M98RUO/Ji/0=;
 b=msC6wvgyOpXu063XoAqdVTpAeoy7p+GHD3z2aq1OKmUbFBWBV/fhjQ3tBKPE4oAhwiBq
 KHp0p91TyRGionPHH8zwAGNlyGx7K8RDBdCKwsOlb/K4wGRxLZ7y4N6vsZYJ/9KBw8Z2
 2f7YVid7ycubYWHAK7GnxcHK76V2x/Gtjaen76is4NfdVZZm+CCqsrMYa31q+T7ew6dS
 e1HbJF3J2M7CyHY8tSObhwEraFkErz6i+e9Z30ROKJG4EUGA+XQjH7x16mYUDIvDrUlR
 3Z7ERdJlpyBiaVWYx9UavK1E3cOFsHTDlALR7ERJuoMQHQCfBiJRux0xiqJ3gc2zr3jW vw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m2jqm0x2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Nov 2022 10:37:49 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2APAPj76028084;
        Fri, 25 Nov 2022 10:37:47 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2048.outbound.protection.outlook.com [104.47.57.48])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkf35ka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Nov 2022 10:37:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=REG74eto7g/PtOKWDaJumSRfq8Vv4VZITyUJ4qFHPuvx0S88zBNtV2GYfvz6HPgSDuGzLVyYvhnXeuTeAfFb12TmQYRbKWQXlaDw95oKZfFX1AUpilP7l5zUOASuFxNc9/CGlYAhJ0n1KRNYyxHePBoMFe0fCQu4FyQw92fXHR4bFHTpp9T1U3KuJ4eIRLTmgAycqP7/KkPhG0hpoXzyYwx674pieghzGtqH9PEt3FmVf68maW0WLyHs8nanKVA4oiGTRRC+LG5Uc5YSiDace/QyD/OIHmHhFzfjuh8HoGGBFd74gjFRHXxPeJfhoMhR8V9xP5HfqscYwx9uqN0LtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FcXLKR8baP5jQC66ujBvpyFLtwzGiKE8M98RUO/Ji/0=;
 b=cHQvqgd2FJfFRw5wRLBzxeFKRD5l610FsdaFPGmL3ASPBbd6rzM1JyTdI4oz1s1WGdt7fbeVj7KcCeDB8/AIjQ7MLySdRCMnGwLb2txk7pxq3/ESKyHjVIXr6GSNDBfZ30oehAcj7bP9d7iehL0yaLFyXt2b6QditJgQj9bobDzTqMHC9GPHw7oUSjTBXlVwOJ80SX/qa7UbCSQNUYvzcJfUZCDglUzWJZ4Lfsobc3FVOZD9e3Ic55JzuajelsRD1+KcElWi8myD6SJcV2qv6FdlgMcaIPZ2E6eZvNnl9Zo+mCzVN5XBe0Oll6RgU2lvsH2wbUEBRw1qS6jqpE8rJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FcXLKR8baP5jQC66ujBvpyFLtwzGiKE8M98RUO/Ji/0=;
 b=Ot3/4+Jh0SOjj9w4zrGMhyO2EpUtC2Rg5+mP3FGG8ycQu4siWttH9kDy9p7z/WxyeIcEK0iRVvymTN4mXPkmhMyOl5D0r0dIMOyxwyFzQz4pYVo1+EKzBU2Wkhiw+yBp301wOTBD8H3nMgTt89yAYifw1M1zH/XXuJaotQLtKUo=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by IA0PR10MB6819.namprd10.prod.outlook.com (2603:10b6:208:438::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Fri, 25 Nov
 2022 10:37:45 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d5e6:f75a:58a4:2e40]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d5e6:f75a:58a4:2e40%9]) with mapi id 15.20.5857.020; Fri, 25 Nov 2022
 10:37:45 +0000
Message-ID: <8914ef49-aad4-1461-1176-6d46190d5cd8@oracle.com>
Date:   Fri, 25 Nov 2022 10:37:39 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH v1 2/2] vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
References: <20221025193114.58695-1-joao.m.martins@oracle.com>
 <20221025193114.58695-3-joao.m.martins@oracle.com>
 <Y3+1/a25zcxNT3He@ziepe.ca>
Content-Language: en-US
In-Reply-To: <Y3+1/a25zcxNT3He@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0364.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::9) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|IA0PR10MB6819:EE_
X-MS-Office365-Filtering-Correlation-Id: b882ed63-1ad1-44a2-1b0c-08daced116ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rr2Z2BAyPQh32tFQQtxEJh8MCDddUE2wSUjoy/JsT4PUl++Wwf0LrM6YXiAntJ1hrEieGnScftsZ4xg0hBFDRpdPRrUtkpAAGEvEJfqJmxFtMh0cyiErtjsjKmbt+KSkX1JhLYkl8DCvyA4j+6fKkCOUYxkRIQt6HVU36VrCoj+jIds9jN3wTyDIeftiQTZey/AYhg6pqu0VDNlMqo1zIfCoB9Cz5r4/EvvlFZv0KhTIKxparP2Pc2PuLqUMybdZAh8b92sCp0s/Mio9xtZ7eQYyEo5KcZtGBQMLKzIJ8Qq5zgoUp48EslZENXKFtqr2Qt8HZWiJX0bDVu7Rlz84fHymalt7frPrO2fog+Ez8tIG4uyPvwfaE0gZYCrO4Gzz35afbtP2hXkfxqLgtDYrqdW4t6oKnia0NLyKfx58dz4gvkk7IuhArpItxgTLXjXVQcYnICQD2nWSS0uPqUAEg0cCRsmIsxNVUlHu6UfQ7YqWU5yrxkPtHUfPG9ZNP7nuwWNEQltTd/1brYoNTRlJuGeSf2od7BqqBwY0aTdxaT2rXvmku72evPrJt9IOXCZ7/js65/vn2bI+xzonZqePsvV0jRaM+Zp0ZC3mn2miGT2jZlqQbgjvHwlm3C1LnIAFrQmzqrfy7POFMPBd/yWpXi0CRFgdtC/Fw9a2KbJBcWHLOLg/KtYNqfLWeEBwe7ec1xPCD8zSfTzmdk/BrvpmGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(346002)(396003)(366004)(451199015)(31686004)(2906002)(316002)(54906003)(8936002)(41300700001)(36756003)(26005)(6916009)(31696002)(86362001)(2616005)(186003)(5660300002)(6666004)(478600001)(6506007)(6512007)(53546011)(38100700002)(66556008)(8676002)(66476007)(6486002)(66946007)(4326008)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUtEUXBVSVNxZWtBYkhlWmlweENGRGdUMlZxV0czTitxM1pid01GRnpNb2o4?=
 =?utf-8?B?allzT0UvcGFNZ3FCQmxQUDRLK29SQWZncElFek9iSVJVS2pMYzdhR09EMmFE?=
 =?utf-8?B?U3gybzNRdzZPSlc5WDNhSnFsU2l3S2hvcGx5ai9ZMmZsd0tQall6ZGF4WGt2?=
 =?utf-8?B?RzJHY0Z5ZUtmMElhZVhTQTVXdHdrNFlTQjBNWVJka1V1bmdoTHZDMFVRbzVt?=
 =?utf-8?B?N1c1aHNKT3FlWFJ2aVZ3ZU1ST2ZtbUtjdkhMSTJtUGtneGpYNkdrdEo2dmor?=
 =?utf-8?B?eExEUHg1VVhPcCswTGlYQWQxcUtpWGVyRjJLYWRkN3kxRi9SN1ZGaEc4R1px?=
 =?utf-8?B?c0E2SDJkdEQyNytOUWI0UkJJdmRuNkhhcnZlY0xOSnFoN3RWZWFaOGtyUkVx?=
 =?utf-8?B?U3Z5YnRvZGNyaFBpNkREL0c3eTlaNDFNWnl3T2NyUHcvaVMvRVdFRTgvb0RY?=
 =?utf-8?B?WVRKL3dqZFVtS2F2TnhHTVU4QVJtYXBuaGZIRnIzUStici9KcXp0QzU2bHBr?=
 =?utf-8?B?M2pjN1BkblBaYWxGeVpMenBpcDI2WC9aYitvNmZOcWtLd0Y5RG9Kcyt5a21a?=
 =?utf-8?B?SEVOdUV6MmZGYmJpcytvQXJkclpNbjlBdDhwNThEZE5WQU13bXVQL3hxaWdm?=
 =?utf-8?B?ZEczWUFKZ1BZS0FKS3RUcGwyR1hZTUtvWUczRFpwU00vMUpZSnFCd2RvV1RC?=
 =?utf-8?B?bDljMmUzQ2R0ajJnMlE0Z0VyYTNTNFhNczBibXA1VWxZTzZ3MVk0UHJMYllu?=
 =?utf-8?B?STQ4NXFmR0JBOUlZTU1pT29BTkdBcm82SVNxQ2t5Z2RWTXE1bkhCUlhPS1Zz?=
 =?utf-8?B?elM2SEJBMG4xN1NERFloR0ZsME1DQ2tNNHJpMHRSeGI0QUdBQ2wwWUR3T1Jj?=
 =?utf-8?B?MHQ5QkRuS2ZXUWIxSGZBbDhyN1BnRjlYZUM1TWRSekM3MHBWWStyQ25XWjdm?=
 =?utf-8?B?TWlFWlJmS29KRTdhbHBzZVhLbUZ3WTVOL0JKdURORi80YmtUMTl3TFcrb0pr?=
 =?utf-8?B?aWhDUi9NNjNrWnRmU2tEQUpXS09TcXgwa25zMTBsaWhJQjErdTc1QXZEd2R5?=
 =?utf-8?B?bGY2TTVtVHNxZUNxRlBrNHNkR2hTVjIxQmhqVmhvMU40RDFkZ1VFZ2RBR0ZD?=
 =?utf-8?B?MTZBWjFsVTR0OFVNZjJhMEh1RWZybmVMV21vU0tBVGQ1cWZmbHN5TEE3dU1D?=
 =?utf-8?B?aXI0R3c0cVdxTEJpZkhKUTJiTVZHZDd1djB0T3FEU0tWQ1AyMFBuUk1sS1Qz?=
 =?utf-8?B?UWdHZURPN1J6WkFCRHE1RE1rejBwM1V6VG1BcUhaVE5mTGZDSXFsV1cvMEpL?=
 =?utf-8?B?azQyNzFlbUJoQUxLaUZVU2lmMm9IcEJRL2FpS2ROSjltMEdHbWxUT09OWFNy?=
 =?utf-8?B?WXNDNTQ0OWYwRitzK0lkTnU0T1VpZ3NVWktPYkoxK3IwOXRwdk45akZ1QU44?=
 =?utf-8?B?UFhqQVVBS2N6eWJtVWVXUVhMMWpKa3FnWHVxd3duSW1VTHh0eS91b3JpYmpv?=
 =?utf-8?B?MnVlWWpmYjRyVzM4WERObHZXY3VPbG1DczN0Ym5DbFNrcHdwYStiNzBDNmVi?=
 =?utf-8?B?RFdvWlp1Tkc1V29IQTgrRDJScnRSVTNYN25ORjNpMllqWStNTVZtRFhldnF6?=
 =?utf-8?B?MEE1aFVSeFphOVJMYUc0U09aeXB4ZDJjUUxEcllSNmVPTUVOUHBWZEMvSCs2?=
 =?utf-8?B?L1JHaU1UNVhDTzJ1Zk1GT0VoVjl3UXZtZXRpRGZCMVFLTzk3dW9oSE5PSzF4?=
 =?utf-8?B?czcxSmIzcE1WdWg2UGJOSzJ2TThkLys1aCtNL2tUSGk4ZFB4MXdDdURyU3lQ?=
 =?utf-8?B?K2tnOVgzekswUXR2STRjUXB3Y1B6RGFMTEpNNU1TNkVRNDk2OTMya0FnenFr?=
 =?utf-8?B?VHRLZkFUQnlka2VKSWRwZFhlbWVGUGt0UDkxYmticUlhczR1bHhQUExId0Yv?=
 =?utf-8?B?WGZjREwzYit6VGNuWml3SG1rVHYydHp6SlU0aElSMW0rQlFKb2hYMUIvREhQ?=
 =?utf-8?B?VkRmRmkvWE9pdVFoc001MEs0TFhVNXhQcGEwdGZ0WWszb29KelNLbGxjb0pF?=
 =?utf-8?B?S2RZbkxxcXF5ZEhKdzBsc3U0WTZ6SDFMbUpXbGprbUpOb2ZQRkRIU3IxVG9w?=
 =?utf-8?B?dWdrdDFqN2NzWmlvZVFCLzh1YkdyRGZ3L2hyL1FuZldTWEdTQWNlQzlzbHRX?=
 =?utf-8?B?RUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: EXHb0NDaV4esU3AvlWAeGawxF7TdEc8gwkgkCjmRCK/ddaGEC1V1xczTQXb+zignhHHhxjKjQS+E3bYgkN6wT6i4LbJkBCYBUF8oQJit6dBTx+tLyjm4onE/NBD8fCWeiUOR4d91y1O6nOcF4x+zhSPT76Qwv4spcuUk8UtNSXJI0HedqFBdXK/v/3BLzG+4OlRTDQKlL1NUT1chSU4gKSlXq+J+UNP0ZVtiGTucWe3o/QJIO+mM2KkMr3eKShTPZT3BJKFxzWVLnsvkYMajlaCOfktEgL/YAOU5iBwslO76g0j+3E8bn1L0GPXa9EB6GxgM5OwuPTW/O6fsVstAn5J5YwlgbtoenA35vGCOZGojZ4B0BjBx0qjEhw0F3PA0V9T+DzA8N5FYGu9s6OaLswVBSVXT+hdRrB/6fPEHSmEKf2fk1Hq4lNokPYvulqlufyNah0Zix9/QnY1tcXkl/BK7b4tOQDH99ki9UNBmjjzYl+wW9nv5IL/18+UiLF6mib9cSzSHAFeX2oY+5XSieeoPef+IRBQUsykmJGwoW/Hcq+96jqtbiWytOge7ka1CTgyTB3ydvDR9Rb2SuhKnK/SwB/as5AjUI5T4logrUuOfMlJP0AqNANMN01+RUqY2GJY9cwVdH11Yl6fwElPAfqBkYMHc8YmBIgCSIsEoC915+Kdxtrbsw3krBC6mlavh3q+S479sLlcENnAvKuaTnTh5H0KyeBV9JLGO7fs/M3bNr64ARx6NoQkhHmL9J0V2/M6cLcDOdc2wP91HI2ygZTvVLE50AGvxGboYAzccHrwUyjQ5WLJMZGz8qm7ABWtf4/G0RgyOIni4tdj8JrBlddnxH60HjDDrFQ66JCyp2dwtjJF/red7t2EVC/R+AbG/aG4b/dSmVHV4xxcCa5Cakw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b882ed63-1ad1-44a2-1b0c-08daced116ce
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 10:37:45.4171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YctICzPKB/eq2Gu9nOv+Loqmj9+y/XBzeqeD9+dCuVth9+0oStOY89uNdqUltS4X9HyGPSCMkvfB8hxVIqZ1Q9vR1C6uX3ISFFtRMAIJhiI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6819
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_02,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250083
X-Proofpoint-GUID: uU4LW_7d9Mn92ly1oMYKXM3LRqEe6fmg
X-Proofpoint-ORIG-GUID: uU4LW_7d9Mn92ly1oMYKXM3LRqEe6fmg
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/11/2022 18:20, Jason Gunthorpe wrote:
> On Tue, Oct 25, 2022 at 08:31:14PM +0100, Joao Martins wrote:
>> iova_bitmap_set() doesn't consider the end of the page boundary when the
>> first bitmap page offset isn't zero, and wrongly changes the consecutive
>> page right after. Consequently this leads to missing dirty pages from
>> reported by the device as seen from the VMM.
>>
>> The current logic iterates over a given number of base pages and clamps it
>> to the remaining indexes to iterate in the last page.  Instead of having to
>> consider extra pages to pin (e.g. first and extra pages), just handle the
>> first page as its own range and let the rest of the bitmap be handled as if
>> it was base page aligned.
>>
>> This is done by changing iova_bitmap_mapped_remaining() to return PAGE_SIZE
>> - pgoff (on the first bitmap page), and leads to pgoff being set to 0 on
>> following iterations.
>>
>> Fixes: 58ccf0190d19 ("vfio: Add an IOVA bitmap support")
>> Reported-by: Avihai Horon <avihaih@nvidia.com>
>> Tested-by: Avihai Horon <avihaih@nvidia.com>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>> I have a small test suite that I have been using for functional and some
>> performance tests; I try to cover all the edge cases. Though I happened to
>> miss having a test case (which is also fixed) ... leading to this bug.
>> I wonder if this test suite is something of interest to have in
>> tree?
> 
> Yes, when we move this to iommufd the test suite should be included,
> either as integrated using the mock domain and the selftests or
> otherwise.
> 
So in iommufd counterpart I have already tests which exercise this. But not as
extensive.

This testsuite is a bit more focused on all the functions in iova_bitmap and
making sure I iterate the ranges right with small and huge bitmaps (up to 4T of
IOVA space bitmaps), and testing that all the bits are set as expected, etc.
I'll see if I merge both of these, there's probably no need for two separate
units in the testsuite. The only test infra need for standalone iova-bitmap
tests was the fact that I use GUP, and so I couldn't but this enterily in userspace.

> This is really a problem in iova_bitmap_set(), it isn't doing the math
> right.
> 

Ack

> 
>> +	/* Cap to one page in the first iteration, if PAGE_SIZE unaligned. */
> 
> Why isn't it just 
> 
>  bitmap->mapped.npages * PAGE_SIZE - bitmap->mapped.pgoff
> 
This would return a higher than necessary number of indexes.

But in fact the logic currently is correct and if we instead fix
iova_bitmap_set() this new capping I was doing isn't needed at all.

> And fix the bug in iova_bitmap_set:
> 

This is right.

I'm not handling cross page boundaries right in iova_bitmap_set()

> void iova_bitmap_set(struct iova_bitmap *bitmap,
> 		     unsigned long iova, size_t length)
> {
> 	struct iova_bitmap_map *mapped = &bitmap->mapped;
> 	unsigned cur_bit =
> 		((iova - mapped->iova) >> mapped->pgshift) + mapped->pgoff * 8;
> 	unsigned long last_bit =
> 		(((iova + length - 1) - mapped->iova) >> mapped->pgshift) +
> 		mapped->pgoff * 8;
> 
> 	do {
> 		unsigned int page_idx = cur_bit / BITS_PER_PAGE;
> 		unsigned int nbits =
> 			min(BITS_PER_PAGE - cur_bit, last_bit - cur_bit + 1);
> 		void *kaddr;
> 
> 		kaddr = kmap_local_page(mapped->pages[page_idx]);
> 		bitmap_set(kaddr, cur_bit % BITS_PER_PAGE, nbits);
> 		kunmap_local(kaddr);
> 		cur_bit += nbits;
> 	} while (cur_bit <= last_bit);
> }
> EXPORT_SYMBOL_GPL(iova_bitmap_set);
> 
Let me test this and respin.

Not sure if the vfio tree is a rebasing tree (or not?) and can just send a new
version, or whether I should explicitly revert the already commited one and
apply a new version. I'll do a v2 of this patch and wait for Alex direction on
where to go on the v2 patch in case I need to go via the latter.
