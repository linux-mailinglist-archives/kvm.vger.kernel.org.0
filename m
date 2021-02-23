Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01A73226F7
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 09:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbhBWIRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 03:17:11 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:51918 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbhBWIRJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 03:17:09 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11N8EgtD163512;
        Tue, 23 Feb 2021 08:15:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 in-reply-to : references : from : date : message-id : content-type :
 mime-version; s=corp-2020-01-29;
 bh=OntSlJl2WJtaSl1NDlhyrFZobclcCkj6pBH4IT1iZqs=;
 b=JoKIXs+ybqajd7xDdA3z5paEY/xV9bj7Vz7YpACwZk6xFVppmEegb0csEeLjjUGWMkOj
 60O59w+daqv/6vmF0ldhnemRhs4aDMdCQQRS9O3IAY/jZDgynltSNy9Dz6z4q4D0cGrJ
 ZPBd8e0X+mgPgUib75Dc0CbrcG1g9FGAY9km2/Ccrt9YFMBxgqJ53dUeDLBe6ujkbKdy
 NrbyuLdAE4qND372ROe7vLDQJPPZ0lMwZY2cUFbb+RTZFqs/Bcwoo9u5ZB5Zk3ThKjmA
 6nEoipY+SL2OUj0mAWEFIJtlSEOPh/hPrTnEPf5YNu19YhMhJlkGuHxZoSXW+Sf/3wLi mg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36vr620na5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 08:15:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11N7uWjW151359;
        Tue, 23 Feb 2021 08:15:39 GMT
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2057.outbound.protection.outlook.com [104.47.37.57])
        by aserp3020.oracle.com with ESMTP id 36ucay1wnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 08:15:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MecSoN+MKhWvlrxXvWcdFywSI2RO6KJKOo5h2i633DG8agRZyCSe0Q+ljYRRVAp2s3WcAwG/Cl+jrQxXO29V4pRBeC0ddjLyaAt90VlpA5NYv04U7V4iGZQ2czp1DfGny0TAL7h1JGLGyxkB00yV7S8eck+PkMcPROynYJ6rMJmTymAVMxTBk+QmpPdy1o5zo+sDndvevBJqCoiSOn1wz0uEssKgJB76WqhVm9tNfkOGKvJJRuqTCtWRbj6hh7PLnLlfBj9rYdJZAnHZk/GL/V7keBqaMurTSCySQnuLSUg+dOMoYbBpchsViF5buQTKrHMmIET12SjL04K5ceFB0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OntSlJl2WJtaSl1NDlhyrFZobclcCkj6pBH4IT1iZqs=;
 b=RDyEA/PCJpdRFv5UL13fkWuWFPTSoY/8fJAlN4k9BvnelqJm7xaoGJaEXOQpT9nkgg6aXrSW6xa9ZLcK1AFEB5FY7pvMCjX7guaMW5et7l27rSkb4RYJNdR5N/KxqFokP1EkNPbjDu4wQREJSpZcSNPrKqLlFnUu8fZ3HdofjUOk8G2jhoqMQjWEp1hpxWszARmJ6SIVe2znUBwttwYWnU59gnqYRpcDYvLOhkc9nhNDwZdFMkU3GHyySUBnLlPfQ6e3ZDUh7BZDfjzR66UD5ro5ZEWHH0ZuAw0gxpTup1iokzh6yTAGS1vYkBShJy6Y54dlRGpTn7kpf6wMPjecJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OntSlJl2WJtaSl1NDlhyrFZobclcCkj6pBH4IT1iZqs=;
 b=FeM3DwRoySMF9/vUgp8js7wfEp6Q+H6NRoHYoSwSeGp0eG8vSOsyHaYThYjg1hbgCC7TaHFfQwvjbvdU9DL3iQ0R2itwAgPMnYILohuDrXJDoopCGk1wLcOb8Kn4CmiMBz3b3mHlaTzFw7LWNz9xuTw8N/qYe9OAySU99BBm38k=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21)
 by DS7PR10MB5310.namprd10.prod.outlook.com (2603:10b6:5:3ac::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Tue, 23 Feb
 2021 08:15:38 +0000
Received: from DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934]) by DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::f871:5965:2081:3934%5]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 08:15:37 +0000
To:     John Levon <john.levon@nutanix.com>, john.levon@nutanix.com
Cc:     jasowang@redhat.com, kvm@vger.kernel.org, levon@movementarian.org,
        mst@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2] use pr_warn_ratelimited() for vq_err()
In-Reply-To: <20210222112947.3697927-1-john.levon@nutanix.com>
References: <20210115173741.2628737-1-john.levon@nutanix.com>
 <20210222112947.3697927-1-john.levon@nutanix.com>
X-HGTTG: zarquon
From:   David Edmondson <david.edmondson@oracle.com>
Date:   Tue, 23 Feb 2021 08:15:31 +0000
Message-ID: <cun7dmzw670.fsf@oracle.com>
Content-Type: text/plain
X-Originating-IP: [2001:8b0:bb71:7140:64::1]
X-ClientProxiedBy: LO2P265CA0162.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::30) To DM6PR10MB3148.namprd10.prod.outlook.com
 (2603:10b6:5:1a4::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from disaster-area.hh.sledj.net (2001:8b0:bb71:7140:64::1) by LO2P265CA0162.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:9::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.31 via Frontend Transport; Tue, 23 Feb 2021 08:15:35 +0000
Received: from localhost (disaster-area.hh.sledj.net [local])   by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 059ba985;      Tue, 23 Feb 2021 08:15:31 +0000 (UTC)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e21b6bc4-3201-4525-d2e1-08d8d7d332a8
X-MS-TrafficTypeDiagnostic: DS7PR10MB5310:
X-Microsoft-Antispam-PRVS: <DS7PR10MB53107C1390AA50E8DC28CCA988809@DS7PR10MB5310.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P97v9fAR8Tb/Z95Z6mldSi87KROQ0HmPBGgIgH0bxvz6zH2XMxl3Uj9cClm/O8ft++qkHrMmFSwm9DbY0ziYht3WYd0T885mKjNaSZFkrl6KTlzHPjZEAShLbPc1MA4EbaWdi930BjOTNyVhw7cuA98UEVtmTyRAi6B/yJqMWtzO3T6fx55LO4U91mUcSn6Fd/+V7zfwC128L9Eb+QiMjYZ2F8CTAfl0w1nkPc6/blQzGfKbECx3sN05EF6+4JfLIoC2X5HNJqr4X6QpotfXA/COtju/zCAOuNHcjmc8W+Pj/vswmwiK494c/0okrwTQW7YgxsobV9Zok+JKNywMMDvI0G//mMOX13RKGblV2+cXehGuXh0hAPuEai7gWZVk4LxaB7GeEbCMHWk9+obEeZtn8VGQvXnsV+9VCZNlg7e0JHNeBmRUWspu0AW9U2EPwnpuL/wL+AFr6DCu1rbc9juRRoz28b/z4+Ds78XAj6xK++7M4ZVmhxy3+67zLOEpOrl2c6mxBv/jZqR8AHB11g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3148.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(136003)(396003)(366004)(346002)(44832011)(86362001)(478600001)(4326008)(2616005)(66556008)(66946007)(186003)(8936002)(5660300002)(83380400001)(52116002)(2906002)(8676002)(66476007)(36756003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?X/DgpUHcpkckkxxflgaOhrNlbKfZ8p/SwRQ1nXeUm9ZaS/w877FuWbIOxqOQ?=
 =?us-ascii?Q?+cZRjU+JgiWT45Sdb3WL7DD1jvGjQx6RWZ3fGwy4sa1QLA0CoPtHLZYPdAap?=
 =?us-ascii?Q?/BvZH048YAjlpfoOuV0p1HLoVRZC7u10dPWLdCuBTtW69YULjsIjdT/+HZya?=
 =?us-ascii?Q?vE0h38UYZljuEm/8wK71Z5enYT6vWK3TEpsiKKDidBZoIgVU1TrUfV9Pz1hb?=
 =?us-ascii?Q?/QAP21b8qsa8an15ksOlYAk6EwJ7VevBZpfYcteolzrXTR1UnBEicBDweetC?=
 =?us-ascii?Q?SbX3F4XLxGlKVxaH5sxx/Fhrsb2KrKqrE5TA+gpM6wUwALjRvnCHobmkClYp?=
 =?us-ascii?Q?sVKA1g4TsjxtuYS2I0HFEbfc9ElywmynRyuy/uUzVJ/R4ofSrMqxWAUcaZZq?=
 =?us-ascii?Q?9/A7MwrZQzDTwX63MbWTvh6NgjIhtaTthj8nwO02kaHH9c7zmZ81wUbW6MGE?=
 =?us-ascii?Q?FS1P03VSXaybxUP17C1TF97AngdHtK1sXkoDbCMUZ1PIBFwyrCoJ+erXOJxm?=
 =?us-ascii?Q?ktJc3UmqQ9PIbScfWIOvr7uYLZOkPbxYuDbZLxNArJYVF1vRdZmTZLrRNCyA?=
 =?us-ascii?Q?M3INcnvtslYALVVc5N42eKVNpG0lybMnlFLPh6ErHOYJtH7N1O++zUjr41BA?=
 =?us-ascii?Q?WFubUXUYDgRrYsHuAd52m7VsGYb5wetNae3OGoV5mO/fHWsPp4+WgxXfXALh?=
 =?us-ascii?Q?ZUaA5egJIx9IXXqsTS9cgSwQzbjBNzmvGlgs22LseIfMMZ5npeC2Ln2lNP6k?=
 =?us-ascii?Q?RCIiNC4/akl4Mjh3nwfPyGidB5Yhm+zlYamLPrTPvnPHuDor3II1WHqZvofk?=
 =?us-ascii?Q?7KAj/AqzaA3u2rLBAeMMJdawbAeLVtqItSmM5dP2P5Vbn1LW6FAqh4dVpTcR?=
 =?us-ascii?Q?hpVFMl6n+5sQpT90FsrLCv5QL3iFknMgK5nT7QElnAZ6PFfWxQZdSY5qBWoq?=
 =?us-ascii?Q?v+4Oyeh8OJPhBAkgn1euDYIWJ49mCe7tQBVgghDaiyvPgSdFgsuBW9K+L98F?=
 =?us-ascii?Q?R1DVUh7YHhPn7dibA/wPCXNteUtOMF8io0VsLx/xyZuRRZSpUnTMMBT0Qm+S?=
 =?us-ascii?Q?X2nBVj9VoloRSo/wU4FxZHuSFDePJuqrjwzNazJhqS7p19ehhxcix3yiSMIu?=
 =?us-ascii?Q?zesDkIB/abt4wKl4ESVYnjqoKCpS/autIIIdNfCC/Wlj66EHdd/5hN8SK1Np?=
 =?us-ascii?Q?oOT5hziBNzjVOeQvkgUzlwTeYmDbKVba8nFCta4zMF32Ac+MTkVxGA1579EV?=
 =?us-ascii?Q?eG39/JrkU598QJZ0Z+mxFo+091QmqBUG/84CB0KetJjTJs7E2jEZrHfeQquA?=
 =?us-ascii?Q?QIEXKWgHPOtjmeLCmN4qxjbBU4ys4IeUXxH3vSVs77xE+w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e21b6bc4-3201-4525-d2e1-08d8d7d332a8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3148.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 08:15:37.8541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pqymlVr91N3Rx20lnNKY8hB72hLf9Xw+1eW/mJu3r0vRD60HbQn7qzO+rpA9930djRtICFhnC2LTUVF9ZuKVqd/gFk3yLfzkkodlCyfQNrk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5310
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9903 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230067
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9903 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1011 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230068
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Monday, 2021-02-22 at 11:29:47 GMT, John Levon wrote:

> vq_err() is used to report various failure states in vhost code, but by
> default uses pr_debug(), and as a result doesn't record anything unless
> enabled via dynamic debug. We'll change this so we get something recorded
> in the log in these failure cases. Guest VMs (and userspace) can trigger
> some of these messages, so we want to use the pr_warn_ratelimited()
> variant. However, on DEBUG kernels, we'd like to get everything, so we use
> pr_warn() then.
>
> Signed-off-by: John Levon <john.levon@nutanix.com>

Reviewed-by: David Edmondson <david.edmondson@oracle.com>

> ---
> v2: use pr_warn() for DEBUG kernels
> ---
>  drivers/vhost/vhost.h | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index b063324c7669..10007bd49f84 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -228,10 +228,16 @@ int vhost_init_device_iotlb(struct vhost_dev *d, bool enabled);
>  void vhost_iotlb_map_free(struct vhost_iotlb *iotlb,
>  			  struct vhost_iotlb_map *map);
>  
> -#define vq_err(vq, fmt, ...) do {                                  \
> -		pr_debug(pr_fmt(fmt), ##__VA_ARGS__);       \
> -		if ((vq)->error_ctx)                               \
> -				eventfd_signal((vq)->error_ctx, 1);\
> +#ifdef DEBUG
> +#define vq_pr_warn pr_warn
> +#else
> +#define vq_pr_warn pr_warn_ratelimited
> +#endif
> +
> +#define vq_err(vq, fmt, ...) do {                                \
> +		vq_pr_warn(pr_fmt(fmt), ##__VA_ARGS__);          \
> +		if ((vq)->error_ctx)                             \
> +			eventfd_signal((vq)->error_ctx, 1);      \
>  	} while (0)
>  
>  enum {
> -- 
> 2.25.1

dme.
-- 
Slow me down, it's getting away from me.
