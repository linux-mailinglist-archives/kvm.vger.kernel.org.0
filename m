Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A28B36E0B0
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 23:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhD1VHf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 17:07:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56522 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhD1VHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 17:07:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13SL3ltR050172;
        Wed, 28 Apr 2021 21:06:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=pm/Lld39IFnGvD4V1eiLtBXTE3dC3CCHOoLI+uYoC4M=;
 b=zPoyQHDXKd1iBtvKeYWR2L2wP9MzP5ggWbH4N67maakELSS8sa6vYmgDlr/whI4JQEVa
 0l7c9UQVerWxji+qfPjSv1Jdl7czOdReLWyaW4WXdJs6hNITXlDJ4jw9Wz3UrDN3VRYx
 nzywCOH2Wh/el0/0NW3ColJ2pls5s6Ec4a3SLijr9RUTXYyrb6iUbBnnHgxAQ7dsGWTQ
 oi7ePXHfj2M3ENbhP5LMzEcCPriAnTMFUKGtJQUqiJY+JfLSoWvftiFgd8mLVyYEWUQR
 kce+RLXbggEbJ1I21b189p6LsSjc3a9AEu5ltRTEMCNneuXXTy/KZt5XMc9/ZTUQuvpg mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 385aeq2cjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Apr 2021 21:06:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13SL0Z3X052688;
        Wed, 28 Apr 2021 21:06:18 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by userp3020.oracle.com with ESMTP id 384w3v8f8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Apr 2021 21:06:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lf2EsX1kwupaIITX4zLkROcgpLK/KS9YfFg2UzetghNCZB2Esl52KEZj3Y+PmV1U2SU2Q1iSsLAo4znv53X0tcnZMpj64Bh69xHZx/MsRjVvc4YLtWGGzaqRGrS16iCDVpBuRRa9ltlD5MP74hEy/hOQFQNZOd0g9JgTN1sP6t9UIr4aN81vkQF7vxrVmy1H3dpOwFa/PpJxoyFDa/1BMTKEaPzLprCzk5SHo0LQHDjwCYA/bHNe29ogHWFoQlWnI4ugJEd/WDv8EvRtUTdYnq57sFVTEMGIEpGxyVLJU4XaqRETHbYbGQw390hKxjwKR/PkZzGXJFqadn+zfygwDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pm/Lld39IFnGvD4V1eiLtBXTE3dC3CCHOoLI+uYoC4M=;
 b=ajFZP/t+jLzyboedRR6UP4aAfmc6IgFifKyd9DDGsEPzmk5Ksq5PbgxBOD22snmYZntE13tfOqP9SJcXdjzwtoOINUKcZUMYjVVWOxSi5ZSTre2Vjyo7jBeisb5oOQ2+Hoj1QpFv4OqoSwNdpGY2Z8kL4vq91F7Y1KcFT0CNGoq598ndkFwS7i38G00E1aex7jmswo89wUFcUZzEiwftYs+Qin4YJJr9OV5RE1OUn1n4tGo+9ouXYosvLl2as2tRmbhl3rO3s6LMcXkQlVqL9yYlO5v5Wv/c+HHVhD18fX0pBKwUcey6SiydgFox9Hjtl7jKHYtH+SLnNET2B7/BjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pm/Lld39IFnGvD4V1eiLtBXTE3dC3CCHOoLI+uYoC4M=;
 b=YKlYUmqC4ljyxj/6XKXRhk767DveqNFiuriBXTmN/9sFXMec2VmO66cZc3spOV43nvjKYm/ZC+A2fzoU7LxhvMSgar4k/DIkLiGdh0ozPY6dWbvAnYpzU18ra0c8bTOZTWZfwpZvkoqzzYj+18i1IM98dmLH0dwtPdvGCXR5YZo=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2999.namprd10.prod.outlook.com (2603:10b6:a03:85::27)
 by BY5PR10MB3905.namprd10.prod.outlook.com (2603:10b6:a03:1fa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Wed, 28 Apr
 2021 21:06:15 +0000
Received: from BYAPR10MB2999.namprd10.prod.outlook.com
 ([fe80::50f2:e203:1cc5:d4f7]) by BYAPR10MB2999.namprd10.prod.outlook.com
 ([fe80::50f2:e203:1cc5:d4f7%7]) with mapi id 15.20.4087.025; Wed, 28 Apr 2021
 21:06:15 +0000
Date:   Wed, 28 Apr 2021 17:06:10 -0400
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        martin.radev@aisec.fraunhofer.de, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] Untrusted device support for virtio
Message-ID: <YInOQt1l/59zzPJK@Konrads-MacBook-Pro.local>
References: <20210421032117.5177-1-jasowang@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421032117.5177-1-jasowang@redhat.com>
X-Originating-IP: [138.3.200.23]
X-ClientProxiedBy: SJ0PR05CA0116.namprd05.prod.outlook.com
 (2603:10b6:a03:334::31) To BYAPR10MB2999.namprd10.prod.outlook.com
 (2603:10b6:a03:85::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Konrads-MacBook-Pro.local (138.3.200.23) by SJ0PR05CA0116.namprd05.prod.outlook.com (2603:10b6:a03:334::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Wed, 28 Apr 2021 21:06:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fac15eb-65a7-4000-00c8-08d90a897593
X-MS-TrafficTypeDiagnostic: BY5PR10MB3905:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3905ECFD5B4C04C996BA2F1C89409@BY5PR10MB3905.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 48VCr6sixk1483b+hyzNgzp0dZGhuQElmDHpoAQvRoWeB8uyew5sDsCtcNinCQ39ERCzNBVuCPFcEbtrHuPKQjgmWvbAyRWyWv5lKIE8DzzdMrHH51PJUTdbbQcIYoqUSutAPE8rBLEhUkieRtK+MLBLaBnjVj7wysgUXYglNELvSrWcLMWW3HGHfvjtObrMWrbXCZXsL5dMUoU9tnPqGVs62FZTJvgFSTOmmejFKEMsVfYj37k2JDyAbQuFCuYjAHH+qNwlZSkVFMQo/cGi0vzhzCcdvNw4QZY2ReHhY5Fv4i5XCedElwvf41ojw7BKXPFvBN5iQKDvPfC/CUS6Z2qMFKFdiDeWroitYZdXefKCIoxxDrDy4IJTziE93QDvmDLU4ufGHWFgStJ4U+oBql0b4GMH1OyJQDK73WuL9Vn1T2aFaOVR8Kf0qzU1RXYLVvzcOgfsXiZh0oJE8cXNqwxYBq0vCT9qm8OF7vRo1dTSafDGtQLYok/ag5DAMJZ7dpqrZGzWqGohgrRMvvr22N8bHA7cZU7CeMVR3vpFUvQt92Bgheeo9bGdWnHobmgwewpSHOE6xnOst2AZ1NU/GsQZjoO45v5+OWnafFr++KadXtI8ET2+WGCmMjjSMsC2cIvneMyf7iET+ficZUBo/DntewWYOKEo5XuB8DavEkBDdsmBfK+o1tW9YMj8z6IGBy/oudFRS0QQemQQfYuQjfUY4ouxDkAGiLbLL3fCo/w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2999.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(39860400002)(136003)(396003)(7416002)(86362001)(8676002)(966005)(316002)(6916009)(956004)(4326008)(66556008)(55016002)(66946007)(2906002)(26005)(186003)(38350700002)(66476007)(6506007)(7696005)(16526019)(38100700002)(478600001)(83380400001)(9686003)(8936002)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?iGbzxDsLaeFitrOmGedDsi7EiC7Wp2tdUQQIBdPYqLnxsBOYkDLWTaxAC3Bp?=
 =?us-ascii?Q?OnVZ7kP3CEz4xv1RANhM3Uyfjz7i5X0K/z9uyiCNvqn79+Uwaf5KmNAyuZAe?=
 =?us-ascii?Q?QY4M5E6B5AxsZREuX6HBATqqJk0VC4rBz7UKStCXR1OURqG1/WULEjogTcQD?=
 =?us-ascii?Q?19AwwOZufoIAVru8GCN/ET2HRDhZYmnFgS8qWPP3pGBKdCiF+pUklb1oZAvM?=
 =?us-ascii?Q?S0WwlShqiC4mrCuhXyS0W7vNbcEt5kwRKI2OeSiCviZ+Cz7GbgkJ/URWY7mj?=
 =?us-ascii?Q?985KwzGRXGXmGGngZNLjTbOpVt4kD2QM4kYSxKu7BCflhG9MjZ7Q39ehfcF8?=
 =?us-ascii?Q?K+eBde4/Oqou7OyUhR9P5qHWUwAzAg1a+xnOcDhmshMyCluQyjiZ6jVA083U?=
 =?us-ascii?Q?tuqJqxeC9oXhtPK7URRlMibWWIPL0eh7e7k0pGM/hBsW8TodEMg70PcBjrvV?=
 =?us-ascii?Q?AyyZ3O733Z76e273g9f/HS0skCQ7b9a6994r583eSFQmlIOeBMZVqMy5xzxJ?=
 =?us-ascii?Q?JoF97s5IrSoH5pOEayT1xRtz71XkkzPYcDw5KfiD16BACiXbR1f4o7AGorcW?=
 =?us-ascii?Q?IGgiK9pJNXaIH8+aKHQ2J/NDBOlMs/J7h8vwBhrE+8BI9VekL19xViXJd7it?=
 =?us-ascii?Q?HSaKHdpdovWruVD2CqdCv+CqNum335MqzR6wWMGDl2pV44mNIHchEIS/KhS4?=
 =?us-ascii?Q?bYvTpE39MOGDUKfnkL0ddWm8g9NeMsayKBhcFgLXJHOX1CGfr8lOmX4InXXW?=
 =?us-ascii?Q?JIrfetqVxR1sYeq2jNAnTfexgXHqX1mXwS/O/LbP6xy+HSU0croWGMGRXGHq?=
 =?us-ascii?Q?osa/9y8+WxTjKNUtIg+/rsbGNSnB17JyVb3j0MtcPmSKdPx28YlJyCSTHKhI?=
 =?us-ascii?Q?stZVkXMSJEQ8/NdYU7+jkFxW7C3gU7r0Z9P+XVApwElhTF3zJAkHtjl3vzCL?=
 =?us-ascii?Q?NuWfypOR3sumHOsx7DQtWP+QT1A0+Uerz/Ne5ixDuhj3YZzW6DkgWxHhDQm/?=
 =?us-ascii?Q?XtY97la2Hlbwh5rIgTMUCHCZFrnzVgTT3Q7Hg+2zz9LGinolb0W/w6RLsDAy?=
 =?us-ascii?Q?LYOLpqhIw0mzkQpylSB27Izz2/niwvdz5j53UNGMa6U5xSJzHjwahjjU0fkn?=
 =?us-ascii?Q?OxFwBmdQIvWfwEw35DM5EoRd8s+RdsyO73bjwYUBEKmcBVMLkKPFoUzjia9D?=
 =?us-ascii?Q?WocHULecui2EGI6zqv8IOOSeWXfXUWFoaQyBeBAdySTsCqDAZIhgFywOmxet?=
 =?us-ascii?Q?jPlgY8Cg0NiUS8xAtGjPEnivVZxGvFL9H9JQ03+USMhzu7+hsPI986a5CDAG?=
 =?us-ascii?Q?bkU7G0u9BvTi/7bheyPF2Kct?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fac15eb-65a7-4000-00c8-08d90a897593
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2999.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 21:06:15.1989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nk2wi4Sye0ZHqWs2g11QZVSjdLTtYh61ZJF9k2Rtc7X8+FZTryfUiloC5ObZjnd96PLmVFVDKSRPXLnvESV4LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3905
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104280136
X-Proofpoint-ORIG-GUID: S0X2_7DS6bcm45dBFEgLOPxKVZ4-XG2C
X-Proofpoint-GUID: S0X2_7DS6bcm45dBFEgLOPxKVZ4-XG2C
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1011 suspectscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104280136
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 21, 2021 at 11:21:10AM +0800, Jason Wang wrote:
> Hi All:
> 
> Sometimes, the driver doesn't trust the device. This is usually
> happens for the encrtpyed VM or VDUSE[1]. In both cases, technology
> like swiotlb is used to prevent the poking/mangling of memory from the
> device. But this is not sufficient since current virtio driver may
> trust what is stored in the descriptor table (coherent mapping) for
> performing the DMA operations like unmap and bounce so the device may
> choose to utilize the behaviour of swiotlb to perform attacks[2].

We fixed it in the SWIOTLB. That is it saves the expected length
of the DMA operation. See

commit daf9514fd5eb098d7d6f3a1247cb8cc48fc94155 
Author: Martin Radev <martin.b.radev@gmail.com>
Date:   Tue Jan 12 16:07:29 2021 +0100

    swiotlb: Validate bounce size in the sync/unmap path
    
    The size of the buffer being bounced is not checked if it happens
    to be larger than the size of the mapped buffer. Because the size
    can be controlled by a device, as it's the case with virtio devices,
    this can lead to memory corruption.
    

> 
> For double insurance, to protect from a malicous device, when DMA API
> is used for the device, this series store and use the descriptor
> metadata in an auxiliay structure which can not be accessed via
> swiotlb instead of the ones in the descriptor table. Actually, we've

Sorry for being dense here, but how wold SWIOTLB be utilized for
this attack?

> almost achieved that through packed virtqueue and we just need to fix
> a corner case of handling mapping errors. For split virtqueue we just
> follow what's done in the packed.
> 
> Note that we don't duplicate descriptor medata for indirect
> descriptors since it uses stream mapping which is read only so it's
> safe if the metadata of non-indirect descriptors are correct.
> 
> The behaivor for non DMA API is kept for minimizing the performance
> impact.
> 
> Slightly tested with packed on/off, iommu on/of, swiotlb force/off in
> the guest.
> 
> Please review.
> 
> [1] https://lore.kernel.org/netdev/fab615ce-5e13-a3b3-3715-a4203b4ab010@redhat.com/T/
> [2] https://yhbt.net/lore/all/c3629a27-3590-1d9f-211b-c0b7be152b32@redhat.com/T/#mc6b6e2343cbeffca68ca7a97e0f473aaa871c95b
> 
> Jason Wang (7):
>   virtio-ring: maintain next in extra state for packed virtqueue
>   virtio_ring: rename vring_desc_extra_packed
>   virtio-ring: factor out desc_extra allocation
>   virtio_ring: secure handling of mapping errors
>   virtio_ring: introduce virtqueue_desc_add_split()
>   virtio: use err label in __vring_new_virtqueue()
>   virtio-ring: store DMA metadata in desc_extra for split virtqueue
> 
>  drivers/virtio/virtio_ring.c | 189 ++++++++++++++++++++++++++---------
>  1 file changed, 141 insertions(+), 48 deletions(-)
> 
> -- 
> 2.25.1
> 
