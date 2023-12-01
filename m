Return-Path: <kvm+bounces-3067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B3BF680044E
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 08:04:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D53861C20E4C
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 07:04:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91A0F11C9E;
	Fri,  1 Dec 2023 07:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WAAxpXjn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vVRzOp4y"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41CA10FD;
	Thu, 30 Nov 2023 23:04:33 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B16scS1008857;
	Fri, 1 Dec 2023 07:02:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : date : message-id : content-type :
 mime-version; s=corp-2023-11-20;
 bh=tPSxZOG4uLiQbh/AWCfKSogjYCexd6lUr+Sqh3rYkc4=;
 b=WAAxpXjniI7hxZapTMwXZCrqTqqA1vZuaJQ8imQyURn0O38Z52MjD44VkZ37hDo/hoJP
 IXQ0H1RD5TCh2JT7RBAvv6YtJw5rweqODfdOcr4vng8o1L7EG5/I9ylLW+bvpi1s4bb0
 qOCEyW4bLjcNhtckkbFdn/ITtc95Nt4dXtn7W8K7KICjxRS/uT73dgTDwSLO7DIFR9U4
 UI1DKDOvOedzObGgIvnHrtuppFVKuKLsjBGOq5xeTm5puqJ/Z6nDuErE1londsgX0lPv
 W8UNsuYNaOyzLOTCB2MNBUfy3zsokJSMisspf5dmv96Udok2iw9GfuYXbEB14ONRu1L6 8Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uq755085h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Dec 2023 07:02:30 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3B16uXpn002219;
	Fri, 1 Dec 2023 06:59:50 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uk7chuyp9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Dec 2023 06:59:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dpgLUl9yn0E0+739Z8U+qINcDJb6XVw0F1Cmy+uXfT50aKBjJmvXp21IBDf3Dj5eenU/aNIwkgfUlodDiQtd3B03iOdALMmhfKTnfhl7UC4K0Rx6nT6YmD9t6w97/VZUV0YS/mtK/HVwEqIklGfYCmXJu2vBswL8BvrqUnpbMvf3EUu3vHHcp+PubefVLyRsp+lZK5AHettxzGQ1VL1w3E9IwGVnvg+blSlv4I6GqAXJmfxf0mw9nrghrbh8O6eecM10i6TzpmS2+JcYxtbUeIcy5NWOsZvq9TZOhTieIsas615xGLz+sl1O1WIpkJMiRaQtatk9ViiLAsZIGgCilA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tPSxZOG4uLiQbh/AWCfKSogjYCexd6lUr+Sqh3rYkc4=;
 b=VQH9/VcE9b4iKFKo+Caw4eNVL5RE1y/q3tCPYABAMc33mZBBU9dNmXqnCHARpYU0kPMZ8bLDj1EQUxoKot85WQ9Ww1sWQZ1ZYtZbxVetFBwjyrVIUKTbiFVsA+OvqxR69A7z2xD0SKtGArXgrNgNXKdQJKjpTcx3m9nljuAdyhyZOBjbYrcQyt5QKiRq+lpUglzu/wih4nNEygs4xhuuMVZdHe7cbyfWiCqOpPMSk/66eKbIJv+nQdKhB4c2KjAixfmkFOLw//+sELu3Nw2DfY5rzh6RpazLTQ6HMGKgG7QiLaHvk0xa9Mzl+wRH8eBbEfMMWQY0wmhZMM97DNzlaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tPSxZOG4uLiQbh/AWCfKSogjYCexd6lUr+Sqh3rYkc4=;
 b=vVRzOp4yZO6oRCy5hZn4TZOH5Jsv7vguu3ovQh4FxvapWrEKR68u2i4B4Z1qAn4L9vvmL2Vayx50HTpAkdPH/gIipu4c0xhJy8KkMwsSY8j+OskFkmUvwkx0tPsaVuvaNisvyEiSxQvr5lnEFpCK+26peDXuABWQgg2p3pJDwVg=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by PH0PR10MB4535.namprd10.prod.outlook.com (2603:10b6:510:31::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.24; Fri, 1 Dec
 2023 06:59:47 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::10fc:975b:65bf:1d76]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::10fc:975b:65bf:1d76%4]) with mapi id 15.20.7046.027; Fri, 1 Dec 2023
 06:59:47 +0000
References: <1700488898-12431-1-git-send-email-mihai.carabas@oracle.com>
 <1700488898-12431-8-git-send-email-mihai.carabas@oracle.com>
 <6bd5fd43-552d-b020-1338-d89279f7a517@linux.com>
 <724589ce-7656-4be0-aa37-f6edeb92e1c4@oracle.com>
 <277fbd0d-25ea-437e-2ea7-6121c4e269db@linux.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "Christoph Lameter (Ampere)" <cl@linux.com>
Cc: Mihai Carabas <mihai.carabas@oracle.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        rafael@kernel.org, daniel.lezcano@linaro.org,
        akpm@linux-foundation.org, pmladek@suse.com, peterz@infradead.org,
        dianders@chromium.org, npiggin@gmail.com, rick.p.edgecombe@intel.com,
        joao.m.martins@oracle.com, juerg.haefliger@canonical.com,
        mic@digikod.net, arnd@arndb.de, ankur.a.arora@oracle.com
Subject: Re: [PATCH 7/7] cpuidle/poll_state: replace cpu_relax with
 smp_cond_load_relaxed
In-reply-to: <277fbd0d-25ea-437e-2ea7-6121c4e269db@linux.com>
Date: Thu, 30 Nov 2023 22:59:45 -0800
Message-ID: <871qc6qufy.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0007.namprd07.prod.outlook.com
 (2603:10b6:510:5::12) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|PH0PR10MB4535:EE_
X-MS-Office365-Filtering-Correlation-Id: 13768907-c676-40b8-b700-08dbf23b1b02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	XFroiAN+AEWO6tJMc9MewXMF+G19w7HA8YbmtWhP5iDPjyzyskDP3HfacnDWF99/7vMEHBnj5Cz61UVWDD/1xeIgX2Ssb+7oGzxWM8OVdhlXojUg/NuPxYBk+7m08ZUTJId8ejKNyBomuIoj56OlQN5A5rtZsVlW4ePU7qROzBphDmBXQ0Gckudsof8UEPrZpIhg2wPs53C5oFgY9F2efKTCWFFloMHYhyhepN0h97Jbw0YdcMowU+5uG+GidbNLFxBu/NylsA83Zlx41YRsjnmzCjSWS3MW3i+z/kKxsLqkOwOX7m37wgpok4xIqGUPh15TbTw2NXwvWbJxFHHnLtnjAa/rXLaNuaRcoErgdsk+GVSWGKB4xdK4h0O2oVDhAeze7t/ewGxMKUY6WrxLwOrhwvyapM1QD7aKSsfCDV37kIVgynnaiF3nqnvciRnGVZnFk0Pcu1cPTZKMpaaDGcLnGWZVb4/VwspM+NQqx6xUkCi6Rl+Dy7HR9LWINGr1svfZb36uoon3yIFTgAov1aaLwkNe5i7w2+OkoUXxJMnlhhvOd3YQpTCvPFDKJ1pW
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(39860400002)(366004)(346002)(136003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(36756003)(38100700002)(83380400001)(2906002)(86362001)(8676002)(5660300002)(8936002)(4326008)(66476007)(7416002)(66946007)(6486002)(41300700001)(478600001)(316002)(6506007)(6512007)(66556008)(6916009)(26005)(107886003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?VvwOFpCYhlBGLPl5G2LzSco6J0sInMkXuSZ3Hee/qzwLYO502tbKVxx4om/X?=
 =?us-ascii?Q?BSWlYKoQKYElPNWYONPBnnq6nl09zy80Rn48F13dbsry7ryrCSOTKUDb2NSK?=
 =?us-ascii?Q?K0vZgBz690nNcYRXX/iiJs04CjvjRz2sCqzLhmI1XXJB96G7n3ecQydO6LVC?=
 =?us-ascii?Q?Iq8oYrcKEsuVSFwf/RX4fSf94UrbDb689WktVwXX1SF2xrJAm1K8hIL6VdnR?=
 =?us-ascii?Q?0IHmP9+hs93cusF/es9MfUwu7N+6YnyWQybSV3pce794dBMBK6LBewKqHFR+?=
 =?us-ascii?Q?BifQLA6MLi9oMmSzvFQu72U5moQh7+K9Y2dCdjOg0whbJhDBUzwg1IJseJzA?=
 =?us-ascii?Q?7QLNH4X1nyulrxTqTLhykx9azfSrtr/5d8AirjCVj3XkoLTmHbnOy1GDfcG1?=
 =?us-ascii?Q?TEbWmk07eNF+8SyawyzjTbIaK1FzSA3odJyiBNpzVKhULg3WMfq3cwf9mh2+?=
 =?us-ascii?Q?PLWyMA/z4Bg+BTSyP+FJFtApFvRTfhN9cn7/dSboXrI4blmjiPUKHV6+HSum?=
 =?us-ascii?Q?GlZgVfYUJXvvNxqrdZvXsZMr55HIqbT7LBfk5I6PuePi8xqFLZqwIphWyzVb?=
 =?us-ascii?Q?SJgiWXuccZ4n4FdNsywHXaDK1s3h2EfQjyZs+UCd94fGH8R5gwLZ2c+iGpR4?=
 =?us-ascii?Q?cYfB4pe92A+rho8l0YL+h2Cq1I9CQU/s0RkJQ6cF7A1dR5aGztkLoHU1uSZX?=
 =?us-ascii?Q?rNoNlLzk8gQla1jVYqNRsXvXmojQSK5GMoiABsFdZv0IQrw8leWxops47NML?=
 =?us-ascii?Q?QcLR0HnQvGxBetDAuUYw7acGQt4IYswqwvd+C4/xTO+9CTWw3FDK+bFPbbPK?=
 =?us-ascii?Q?6Cc3JoA6RV/Ixl+5wljnUeEXX70Sqm5bWtUecPGH/UwODpZRbO8Xs7dEGUHa?=
 =?us-ascii?Q?+9YwhYQqbTxYdKKKVKCTkUwpL4Qzbt5hZozR+0OkjXulcb+juenG6KbaqtKN?=
 =?us-ascii?Q?szEKWxFCV6WSWloN96TxXyrH6IJSPMvMMMtAjC+6b8slkctw4PEVHkUhLmNd?=
 =?us-ascii?Q?aE59uZSVyb3c0m99cROXaVbsa3+c7SapEEWWk2SpL6zhgVPXIs8eFMMzdj6j?=
 =?us-ascii?Q?mn1/B0ZJ7eMJf9aMuTUHPqeo8MtpYHZOVxr5RHZOMvMkCksFd3FBHo0jPbC0?=
 =?us-ascii?Q?6eZecva+LD0xxBINL77bRKhk8/s/avBEqCAt14S8nbfPjtAke9OW3bwFBfUr?=
 =?us-ascii?Q?7QCqkWUh3nIwpDA2rrIys50QhA1z7Jz+M+EvZc26MhfYmn4w96ZlVC/aslfc?=
 =?us-ascii?Q?zucTWa4AGIBufojkYvK8YuqDZaqcKMpzsa/v3qdDEOROj3+F4/ZHYbHSPYRl?=
 =?us-ascii?Q?p6v4splF2ub+bP9peZbu5D6KGG0XkpEAFMBwFbCKyo5otLKm/1ZDPsGfawly?=
 =?us-ascii?Q?B1k7aA3i1fGuQlRy+TpTgZNY0S5w7PKBeQSZ+Mg+/IsJEdPH+2myQqV9ceND?=
 =?us-ascii?Q?YYu+1i0pJcl7EzsffMxn22ESCKkze1G914JOHybUPSl3Obsdd/csFtj7DBUa?=
 =?us-ascii?Q?P9sZ1jS71U3VRTWPDFc1jpS7lxZv0jT8PxxlK4KYEDIPTBX2xO89L6YLUOiQ?=
 =?us-ascii?Q?O+9uLPDJg2raepteu7h68Yfr/tbgUelCfUxScP/4pUjHWKSzvMUusuIfHxab?=
 =?us-ascii?Q?Zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?/dH8GMjK82Xw2TcxIA1+0OdXFg+LKE3AHa47vlWPdEzOsBJEQPW6pDo0kTp+?=
 =?us-ascii?Q?s/msJ9N2IJXtX2jHEHSpqI5/nNQicNlmmVGqykljX0/l6gUFm+nH0tEQQuvu?=
 =?us-ascii?Q?3Uvj+M7uhm58pSchsRWF1Mv+Expd6WCOvFhXsjunL5miUBaOgJdeTPafhEH5?=
 =?us-ascii?Q?nlydbEIm6pu0GHra/n+UAqEAzqjA0O0JCBSSRq258rqg4z9dtsySXeicwHoK?=
 =?us-ascii?Q?Y/t7H61xIAW54les+WNKeOH0DWKk28jBqJwI2ZPsQmtK9F0C5czBCDNMn+ej?=
 =?us-ascii?Q?89H0gSpkNWNJKob+CbZ46yU8NI8XqwAAX/tgVzilnw1dTNEMP+0CkYdoMgUW?=
 =?us-ascii?Q?TSSkFQV9fcqpeTCij2hAngpF3StJ3cEJT1iFj8Tywu2ejtRIh7cobvQgGyZj?=
 =?us-ascii?Q?2B1NfkgnKIuFUoLb6QGeXbpmMLrxaCBYzyq+HgLlNXRaLoNrtakh7/RyEy4O?=
 =?us-ascii?Q?Eoh1BA8J9ojwFhXqIoaEBhVUdkiZBkOgeIVSnE1rFaB2ZRUZ1QPXDdayNf/D?=
 =?us-ascii?Q?SCiTPako5gxJT24/FbXFTKMiQgKoZSf1AUqhDb5e+yxWNawrkFvvWplWi1Vv?=
 =?us-ascii?Q?P9iRgREn1qGXgnTgr/TNEh4v3TMmcdbktZU7YepvaSEdkERJQMOm/jS+IzJA?=
 =?us-ascii?Q?ERruymPq2upJMrmDbvOLMMEbQSbxJMZZ52g2eK5wsj1O3u7TvYsRgIq0VT8B?=
 =?us-ascii?Q?qv7rGVQliZGNsyMk+U9fpUTn/3gVL0VEFw0nYfR9r6OH8T7P3eUm+z6zlLub?=
 =?us-ascii?Q?ZhL/OXgwX6wETtfYACo4UIIYBKWJ72tVZy4MiiWK8VSegY5FSC4t0FE1q/+Q?=
 =?us-ascii?Q?0xdTfT+rGyP9JBgpWDUwef1uktUkwBCYcgvb+t4Axki19LDly4rTrtDPWLi+?=
 =?us-ascii?Q?k5hlG7rj13O7IVqtspKfu2tZ46Eszu1mrP60DpfPDHMxjJv0mTZ9/j0SjExA?=
 =?us-ascii?Q?otcga+98p37/cjE3Kj9htWCbAAUWKRIudRl1VJyI03gePM7LeLl/bg97Ficl?=
 =?us-ascii?Q?iGL4lAN1M0pnmaiQi2IdAyqCdhEbHt8f3oOM7oYr/fgThEFlBVFRFb0PpwwQ?=
 =?us-ascii?Q?nWAQVhd3XfcFQG8XZZD3ACmSgyYN44GozsYreJFWxakj9Oyog7h1KzQ83Lu0?=
 =?us-ascii?Q?9ZYnplKujsyR01Uw6fK3QTvyH7EvmTLKhLmeCVE8Rh8hdxFQ+nEuGbN+hH9T?=
 =?us-ascii?Q?E99nvvKoeHOIkSUWue0jXFd5KXlQnDn5Bqo6nM4nKJsuWsf7pvAhVIbPk3wD?=
 =?us-ascii?Q?xEC/FN80nXJ0FNy8J/skQhbTmZkGe0DK7vvC29cexVkmLivfNg/rYcctI1y+?=
 =?us-ascii?Q?LSi1ECksJ76UNyjENkmC+b96fi77Y3xbpVrUsEBIHPxbbiQFgCtEahWHlW2J?=
 =?us-ascii?Q?i0j2VuM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13768907-c676-40b8-b700-08dbf23b1b02
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 06:59:47.5128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3uJVP7m5hwD7uNqXSyh/ZziL/XwwZxVgCg4C4Ek5sd0AyOGlY8ExiEQELM728vVE0JMonZy4XZOLW0R2SeMMaM06Itn8mD0Si3F4Kh8Hz/Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-01_04,2023-11-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=521 adultscore=0 malwarescore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2312010041
X-Proofpoint-GUID: ZybWcUdR3PC1Zr1QqteW5BJgCnr684-V
X-Proofpoint-ORIG-GUID: ZybWcUdR3PC1Zr1QqteW5BJgCnr684-V


Christoph Lameter (Ampere) <cl@linux.com> writes:

> On Wed, 22 Nov 2023, Mihai Carabas wrote:
>
>> La 22.11.2023 22:51, Christoph Lameter a scris:
>>> On Mon, 20 Nov 2023, Mihai Carabas wrote:
>>>
>>>> cpu_relax on ARM64 does a simple "yield". Thus we replace it with
>>>> smp_cond_load_relaxed which basically does a "wfe".
>>> Well it clears events first (which requires the first WFE) and then does a
>>> WFE waiting for any events if no events were pending.
>>> WFE does not cause a VMEXIT? Or does the inner loop of
>>> smp_cond_load_relaxed now do 2x VMEXITS?
>>> KVM ARM64 code seems to indicate that WFE causes a VMEXIT. See
>>> kvm_handle_wfx().
>>
>> In KVM ARM64 the WFE traping is dynamic: it is enabled only if there are more
>> tasks waiting on the same core (e.g. on an oversubscribed system).
>>
>> In arch/arm64/kvm/arm.c:
>>
>>  457 >-------if (single_task_running())
>>  458 >------->-------vcpu_clear_wfx_traps(vcpu);
>>  459 >-------else
>>  460 >------->-------vcpu_set_wfx_traps(vcpu);
>
> Ahh. Cool did not know about that. But still: Lots of VMEXITs once the load has
> to be shared.

Yeah, anytime there's more than one runnable process. Another, more
critical place where we will vmexit is the qspinlock slowpath which
uses smp_cond_load.

>> This of course can be improved by having a knob where you can completly
>> disable wfx traping by your needs, but I left this as another subject to
>> tackle.

Probably needs to be adaptive since we use WFE in error paths as well
(for instance to park the CPU.)


Ankur

