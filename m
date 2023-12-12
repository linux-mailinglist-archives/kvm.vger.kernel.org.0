Return-Path: <kvm+bounces-4275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8471A80FB87
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 00:44:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 105701F219CE
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 23:44:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14F64745C4;
	Tue, 12 Dec 2023 23:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ov+XfscE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kFf+gJnf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82278A6;
	Tue, 12 Dec 2023 15:44:19 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BCK3txX010403;
	Tue, 12 Dec 2023 23:44:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=Klg5OygWpBO1qlVLINzviwN02wsaZdr9X/nirYtlF4w=;
 b=Ov+XfscEG+dU9Q0KJE5NVsf49VRx55/o/mz08bNn5DkCRW1pA1CJJ39dA6ZwAeg4B2DG
 /MIrzkyGEemZgzkA/76N7Fns0UkgCQdZtsbLQYwTpCa8xgM7MTPvT1DSmEc4VL4uOZIa
 bOyQdXEm7FPBbv3TMVKUIusGSfIH/0EXZKsAmh+xURxCL4m+q53qzVeafg3ImRxscIa7
 vOHUikqgfXqhc8K5BnzKThFIXlyLKlDYuk52qyMzW/rTS2WOWUtovRMrLRrO5/r1cecH
 DK5Trjpjy+34mWy2GJujyKxqO5Z4BaqMAA+PcupJwh4W2/ppxhlEvVEGjwNGTuyO3+bh 1w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uvg9d71br-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Dec 2023 23:44:06 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BCNXeNf008223;
	Tue, 12 Dec 2023 23:44:05 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uvep7bhub-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Dec 2023 23:44:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=if+0BAY2KVrCwVvnlUXhRMO+Ert36uoUU4maem4ALgDrZzOIut4s/M2uBHKoOkGWZADXNy5aRngRQy8v/SnWEXn9XE5jmbPNBXspSVN+LVmswLMVmmjOK1PI6N/qzhQbjZ14tFyGSAPzAXhAZLvYPip5s/JBEPuRbAQPG98pp4MtvtYfaSBChxBBKzrbq019Rt9ByCOe6RRc2tsfs6orIK1jEF61DU607UrmCDNfLLfH10iZoVk9aOVIAxaNQXAl1AmH+SQ6xYbmIgNwAymToO/nBhU2Uc9vDHOWPo1nwCBISfRgNQASys2UyhAqOtkW1N4aORDcITQqf4Ot9A9ObA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Klg5OygWpBO1qlVLINzviwN02wsaZdr9X/nirYtlF4w=;
 b=aamvMPgl9fI0bPvRMR6pdd3G4hcXNBPLkGZvcHEIYRe61Y3+tQZ5gzA78cYDi9Bf8H7xkIkd6/cS80918TAMVlKtWcMs1atUnoKd6Lzc/+bEH5yZn0SX5/QLyNV1LBQmeRqhZctVqabb/MGUG0FZPQdDYAdhI3JRbum/fBOUb7sCJWLMeC7f1ANsNlvLKakHtQzQ7F2WSvp9mG6JqyrFpMeofGEQbVYhiKl4g1lNlEHYwMpxMhD7cR/b2a2OQLx1fGAizzt4HXmW4931ZztqN91N8NA9+q6HVBEX+VKc1/IG+7WH8kDXGYKVUjE5r7Z+dcZNpkqjIV9Mnb8IOiML+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Klg5OygWpBO1qlVLINzviwN02wsaZdr9X/nirYtlF4w=;
 b=kFf+gJnfODNRG+Bsk55TcqxKeuOQKT57/hIorkKSyqVNmHksQzIN541qz0Mg8nQ6Vf1L+ics+bTGIa0ZkQPOCrLhrhfsWmTIlJ5v8pLyR6VuCNeuNvNUZwPOxhEWvCzXbFnRsWTlsxs0FD/ZSHE6ITDPmnbFR5OpeTxq2Ycju1s=
Received: from MW4PR10MB6535.namprd10.prod.outlook.com (2603:10b6:303:225::12)
 by SJ0PR10MB5614.namprd10.prod.outlook.com (2603:10b6:a03:3d7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.36; Tue, 12 Dec
 2023 23:44:02 +0000
Received: from MW4PR10MB6535.namprd10.prod.outlook.com
 ([fe80::3942:c32c:7de0:d930]) by MW4PR10MB6535.namprd10.prod.outlook.com
 ([fe80::3942:c32c:7de0:d930%4]) with mapi id 15.20.7068.033; Tue, 12 Dec 2023
 23:44:02 +0000
Message-ID: <27312106-07b9-4719-970c-b8e1aed7c4eb@oracle.com>
Date: Tue, 12 Dec 2023 15:44:00 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vhost v2 4/8] vdpa/mlx5: Mark vq addrs for modification in
 hw vq
Content-Language: en-US
To: Eugenio Perez Martin <eperezma@redhat.com>,
        Dragos Tatulea <dtatulea@nvidia.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
        virtualization@lists.linux-foundation.org,
        Gal Pressman <gal@nvidia.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
References: <20231205104609.876194-1-dtatulea@nvidia.com>
 <20231205104609.876194-5-dtatulea@nvidia.com>
 <CAJaqyWeEY9LNTE8QEnJgLhgS7HiXr5gJEwwPBrC3RRBsAE4_7Q@mail.gmail.com>
From: Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CAJaqyWeEY9LNTE8QEnJgLhgS7HiXr5gJEwwPBrC3RRBsAE4_7Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::17) To MW4PR10MB6535.namprd10.prod.outlook.com
 (2603:10b6:303:225::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR10MB6535:EE_|SJ0PR10MB5614:EE_
X-MS-Office365-Filtering-Correlation-Id: ee9c561d-b00c-41a9-ab8b-08dbfb6c3898
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	knZOANPz05hJN7oqjunVOkJNl5S2txy5RHePNc29xEckdoAfWKJHB0WqOWTn1Qt7jTsb8SbK8vRvMrEFK7LoiGZuofjMHNVMzKORVCGScaNcIFgAOhG7BuW3oCp5EvqE2Bk3uTzq3YkzwRP9BA8nEzC3ret20hTwQFFYqLGVxP2yGEdV5CH8igkm2y+zpzpzFicBf2pN0JOm9YYY2Vl1cs+mBlZ2rCMLrAaQF4rvcCunGgufjq+XPXYwdVveyx7VPE4DYFiTAkIKIBPapoPnlicrd5rXiGb7qkSMmgHJSgWnkdawOV2RVLBSDL4UEBsQ/5JZNpfVi2xGvcM1ynkC0tKqZRhyEJdrpbyuYHRHfsZ7alkOvUwAiJCboq0DnX9oBa4sn/yWrjQWOMug7EdmbGwaHK9DtpJG1hE1c6KrdN/bR0c2bGAeuA8UsfgkMf2bXZs9BiFMBmseEvWnrwTCbpreCBHli4czFgw3cQxxXRy5AYdMONgcBOmvwempDhcc5t04FXiR3p1kVbh1g3GYoN3MFcChV8FnhyB7fs1+yQWlPaR8R55goUpKHgqik57MxyGbqG1u95EZaBX6Cx6+LEXnZVv80YptoEIMwz2WqR9eXZVep0DxBxFXl+t27L79c79Np/UL8orgWgRzZ9A8nw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR10MB6535.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(136003)(366004)(396003)(376002)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(26005)(83380400001)(53546011)(36916002)(6506007)(6512007)(2616005)(4326008)(5660300002)(8936002)(66574015)(8676002)(41300700001)(7416002)(2906002)(6486002)(478600001)(38100700002)(316002)(66556008)(66476007)(54906003)(66946007)(86362001)(36756003)(110136005)(31696002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bEIreVdySGFWR0pjVUtqLzQzT1Y2cnV1S2JPeWlwdStKaXo4ZGJUSXhsUDgx?=
 =?utf-8?B?cEhIMEF0N0pZNDQwem1LNUg5TE1DeTdwbkU4a2M0TzR0elg5UzB2ZFlyYWNV?=
 =?utf-8?B?R3dZbUlRSXpvWXVIbHhaMVZnTjk0RnBlMWhzUWtiTDQxUzRidnhib2hET1Yv?=
 =?utf-8?B?bXZkaFpONXlZSitMaS9pb2QwUmdPaTkwOXllRURPT2JTTmN1Q3VVK0dWd0sv?=
 =?utf-8?B?d2pCZk5Eakh5RlR2Z1MyaFZNdzJSUXY0OHBlZXNKMWxCMFlYNFRVSGdaOTYw?=
 =?utf-8?B?cUVSMVlacTIzMnVQRUZxbm5ldXJjMW91dnF3dk9DSTMwMFZSWUZlUXJmNnRV?=
 =?utf-8?B?RStGTlpWL2ZzeXdReWZTMlo3aEh1UkdvK3BxeFBlUTJJQkdUSkplaFNzellL?=
 =?utf-8?B?dVJieHJNVHBQSERHcWFQYzV4T2JHRldPbHMyNkY3dG5NdEp5SEs5ZFVGQVkv?=
 =?utf-8?B?eWxsbW4vS2l2Zi9jSU50K2VxUGNoQXJTenI1TGhGOXovenJDc3RPekJ4Z0tV?=
 =?utf-8?B?RjZlNTZuTVppRTU5RW8rSzRmakRXTVFLY1lwQlBMSENzcXFKZTYvcUdoZmpF?=
 =?utf-8?B?VmVNSHdSZEIzaXF5V25zMjR6aFRvQXJjUWhmNUdpOUlPQmVVVWF2c3hKc242?=
 =?utf-8?B?QWZlWWFKb2JpV2k1a0ZlQXlDQVB2NXRJQWs3TlJiUjNYYjQ4WTlwYkhNZldw?=
 =?utf-8?B?WGV3bkh0MDRtdCtWSXFWQnczTTVoOXRlaDNUTGNsMUZlZnBKM3o3bjdWSWRQ?=
 =?utf-8?B?cjRDblgyaG1iQW9qQ0FzTDJRNFRxUUtLSkUrMkdVb3pGS1FRbW1ybGJyRlYv?=
 =?utf-8?B?bUllV2N2dWs2eDBFTDBhUEF2Q1FPOUZ4U1A2QXo5T3FuQlBlRkFSWVB4Wll4?=
 =?utf-8?B?L0dPMkxGRzgySEROenFGTFpFWm80eDVPQ2xUeUlXMEZFbXBXTFlkTlJNemw3?=
 =?utf-8?B?YUR3T05kRHF1eUpGU2VGcFlHek4zeWlISEQ3R2lBdUtkTmlFdHZtWlBhNEtR?=
 =?utf-8?B?MDhzcExxb3lvUHdwR0U0NTJJNTB2b09qcEsweldVMUUrZnJ1R1VaZnhJalMw?=
 =?utf-8?B?T0ppTDlRWUYwREE2d3E3SnpDdkVNUWREWjBWN0ZjWGUvcXR5cXJHSzA0dkdu?=
 =?utf-8?B?bDhPNWcrZTdVUjVaQm1jVk1GejQ0UUZ4TEFYTlpCVkVpS2xpVjZoMm0zcFlO?=
 =?utf-8?B?WjRwVzNrZjNEelpEMmJCUEZPZENPN3dMZlRveHlWL3RBdUhkWDFTZHBkWmlH?=
 =?utf-8?B?SlRBMG1aQlp0Y2hVUE1OcTFkSXo3bktwZzYrQUJnNmJmVjVWM3oreERTMkw0?=
 =?utf-8?B?LzVjU1d0Z2VBZzBXdEs5dkpCRWRxY0tmVElTR0E2OVFwWnJSbXFwNFJFeHM0?=
 =?utf-8?B?OUFnUjF1MmN3VXdpOHZjV2NFMS9QK1pEdnFVcThxTmVBbkhxMmFxeTdhMlJm?=
 =?utf-8?B?bTF3QWd3RHNPc2liWFNBYnQvNld1SE1XQnVMbDRpbXZwM2ZNNkUvZ0IwZ3p3?=
 =?utf-8?B?NXdMMXc3Vjk3K1RXSkYyRnBnNnZrdmRZN3FNUnVOZ3JJMExsQk05OGJMNjhQ?=
 =?utf-8?B?Q2ZpelI2U29PZkZLdnVZTmJ0dnM2WHBQWEt3ekZrcjJORWYxRFptamNjM3Nz?=
 =?utf-8?B?Z21FWHlsRVVObFAxT2plb2pReEkvcXhhTDRMSGpsOEQ0c2Zkais4Y0dPN3pE?=
 =?utf-8?B?TzIvdWx3RmxNYnBEaC9PNGppRE10M0hjajBKcDY4Zll3b1VjZ3UrbHFCL0Rl?=
 =?utf-8?B?TEJ0a0xNaVdxc2R3d1hlc0JLRkdsSEtRTVlGVWNSZnRFUGxBMGFrZVdLVGUw?=
 =?utf-8?B?UTlJQ2ZBM2c0NTZZNjF3YXhJQjRwOCt2NWtaa3lxbW5oditYT21pSTJtOFpw?=
 =?utf-8?B?RU14TDdzOWtVZEgzR0x2bUtpK1N1UnEreHVsNStYRFIxWnk0OVVaOGwwUjBn?=
 =?utf-8?B?dDJuMnVmbU1FNEFpRFFjYTNtbnFFVjR1RDdERTZGQytiYmdYRUNxUjZ5dUpC?=
 =?utf-8?B?SUphTDBlR04rdFlFRk5kQVBBYzFPc1dQNzd1QWtvMDFEVUtCZWlocnB4bGNQ?=
 =?utf-8?B?VmxwWXdEMHNGYjN1bU5ud1hkSm52cERPdVZtNHNQaE1LRjFQNUxiTlo0TjFE?=
 =?utf-8?Q?8/xTIqaCIDB81uoDiNRFkVQxA?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?utf-8?B?RXh1eUpDaDlXMHNybENWNjFpbkgvK05tTmVXTGZYdnA4N0pqSERrdi9kVHJl?=
 =?utf-8?B?Nm9ONk03Q0pwZWVpZ3NmUExwWVcrNVo0dmkwS0lkbVJPWHowYWZKQVZGRVor?=
 =?utf-8?B?M2Y2Q0ZKeEVYck1BNlc3NHVYc0loeDhYSmpLYjFaNGJKMFRFRlk2RUZqTEZy?=
 =?utf-8?B?WFFrYkorMXFLRGFaQ2hpTVZmWWYxWUk1Z3ZzSXhEc3NlUXNkQldhUmFtOHk5?=
 =?utf-8?B?UEQvZzdHa05ON04xbEpISTFMRUhPams5MG56RENHMGJJdm1scVphZHcwa0I2?=
 =?utf-8?B?L2dWcGI2ZUFJdUUrMXZzNlM0bXArZEpURDlJOVNHYXMwMi9uZlhqenBnL0RR?=
 =?utf-8?B?RDJJQ1hFVWN3c0VkM0pvVjJ4ZmdISjYzQ1oyb3lvTlFzckpTdkhVYVJTY3pI?=
 =?utf-8?B?T05yd3U2YnBhZmtKT2g1eVZTaGxWS1NRVDZxelh6ei9kVkxDd1JKYUhzMjBi?=
 =?utf-8?B?cTVPZFBEMnB4aVRvaWRhS3dyMmtCbmwzakRkMWhyU0JEMmpxTWs5ak5MSHBK?=
 =?utf-8?B?UjNxdkNaUXlKNjJuVk9RRjl1cy96dDk3RjdoOE52WmVnY1RNbXNJS1lzMGhL?=
 =?utf-8?B?Yis2N1VIOC9yWDhyWnF1aDNwOFd2ZExmTEdRZXlrTmhHb0Z3VkdyOW9UaHI4?=
 =?utf-8?B?Z1ZLa2NZanNGOFFqTkRleEk3SVZVVFF1MjMwYkhEeFIxYUxuOEVLUXFIL3RB?=
 =?utf-8?B?eGd4ZnkxSjJibXVBTWZRS095cFNVKzczUndIREpROW41Q2h4VXVkZVhTQWN2?=
 =?utf-8?B?MHZwZzF3UWxjb0tqeG5Xa08zWC9UWEZMeE5Zc0V3ZUJsaXNhU0NuMWVtUE9o?=
 =?utf-8?B?N3hGWlNmRlRkOHhkWm9icERidzV3YkNsdlhKYkcwbCtWaXEwSElTVXRQNC9x?=
 =?utf-8?B?WktHU09KYUZnSWZ4Y0dTbWVNc1prbzk1c2lDczFZb3h6U3pQSnR1Y3dXNnVq?=
 =?utf-8?B?TFhhOEQwVDFEWE1PcjRvZ05JRzFISVBkL0hqVDMzQUxkWXVxRnRYZytOMmYr?=
 =?utf-8?B?UDl4MW5xZW5ucWJHUHBuUEVwQ3RzOFVaazJya2VJbi8veXR4U3QxUnk5cnU2?=
 =?utf-8?B?ZnZWT1FjZmVvcXFucWszd0FadUxIZkdMK1lxUWJucVBiZTdwbWVYT1lLQ1NI?=
 =?utf-8?B?UWdQWklIeHpaS3NKRHFKVzBhTzV1Z0I4UTN6aDVKSHU0UmVyaDRzU253SGRJ?=
 =?utf-8?B?eEk1eHppWXpNdG9nSzZnNzVYZC9xdU5pa2tpZHZwcjhLY0haSC82NWszdWk1?=
 =?utf-8?B?SlROVFk1SWR3azRVYUtteUxSM25aVWNGSmx0d1YzY0cyUnBiaEJNVGRnWDZj?=
 =?utf-8?Q?OerhoTpciFxI8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee9c561d-b00c-41a9-ab8b-08dbfb6c3898
X-MS-Exchange-CrossTenant-AuthSource: MW4PR10MB6535.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2023 23:44:02.8676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EjbXeLABUiiBrGRWnmwS6OUnA576sXspPkwZPCkbj0EgDpaYR57b+UywHtthJ5IVBZSQizkI5DOR7cLC3+h19A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5614
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-12_12,2023-12-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312120185
X-Proofpoint-GUID: ady3aXqUu02jlwIoIFgaMjr74eTfwt_r
X-Proofpoint-ORIG-GUID: ady3aXqUu02jlwIoIFgaMjr74eTfwt_r



On 12/12/2023 11:21 AM, Eugenio Perez Martin wrote:
> On Tue, Dec 5, 2023 at 11:46 AM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>> Addresses get set by .set_vq_address. hw vq addresses will be updated on
>> next modify_virtqueue.
>>
>> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
>> Reviewed-by: Gal Pressman <gal@nvidia.com>
>> Acked-by: Eugenio Pérez <eperezma@redhat.com>
> I'm kind of ok with this patch and the next one about state, but I
> didn't ack them in the previous series.
>
> My main concern is that it is not valid to change the vq address after
> DRIVER_OK in VirtIO, which vDPA follows. Only memory maps are ok to
> change at this moment. I'm not sure about vq state in vDPA, but vhost
> forbids changing it with an active backend.
>
> Suspend is not defined in VirtIO at this moment though, so maybe it is
> ok to decide that all of these parameters may change during suspend.
> Maybe the best thing is to protect this with a vDPA feature flag.
I think protect with vDPA feature flag could work, while on the other 
hand vDPA means vendor specific optimization is possible around suspend 
and resume (in case it helps performance), which doesn't have to be 
backed by virtio spec. Same applies to vhost user backend features, 
variations there were not backed by spec either. Of course, we should 
try best to make the default behavior backward compatible with 
virtio-based backend, but that circles back to no suspend definition in 
the current virtio spec, for which I hope we don't cease development on 
vDPA indefinitely. After all, the virtio based vdap backend can well 
define its own feature flag to describe (minor difference in) the 
suspend behavior based on the later spec once it is formed in future.

Regards,
-Siwei



>
> Jason, what do you think?
>
> Thanks!
>
>> ---
>>   drivers/vdpa/mlx5/net/mlx5_vnet.c  | 9 +++++++++
>>   include/linux/mlx5/mlx5_ifc_vdpa.h | 1 +
>>   2 files changed, 10 insertions(+)
>>
>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> index f8f088cced50..80e066de0866 100644
>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> @@ -1209,6 +1209,7 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
>>          bool state_change = false;
>>          void *obj_context;
>>          void *cmd_hdr;
>> +       void *vq_ctx;
>>          void *in;
>>          int err;
>>
>> @@ -1230,6 +1231,7 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
>>          MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, uid, ndev->mvdev.res.uid);
>>
>>          obj_context = MLX5_ADDR_OF(modify_virtio_net_q_in, in, obj_context);
>> +       vq_ctx = MLX5_ADDR_OF(virtio_net_q_object, obj_context, virtio_q_context);
>>
>>          if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_STATE) {
>>                  if (!is_valid_state_change(mvq->fw_state, state, is_resumable(ndev))) {
>> @@ -1241,6 +1243,12 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
>>                  state_change = true;
>>          }
>>
>> +       if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_ADDRS) {
>> +               MLX5_SET64(virtio_q, vq_ctx, desc_addr, mvq->desc_addr);
>> +               MLX5_SET64(virtio_q, vq_ctx, used_addr, mvq->device_addr);
>> +               MLX5_SET64(virtio_q, vq_ctx, available_addr, mvq->driver_addr);
>> +       }
>> +
>>          MLX5_SET64(virtio_net_q_object, obj_context, modify_field_select, mvq->modified_fields);
>>          err = mlx5_cmd_exec(ndev->mvdev.mdev, in, inlen, out, sizeof(out));
>>          if (err)
>> @@ -2202,6 +2210,7 @@ static int mlx5_vdpa_set_vq_address(struct vdpa_device *vdev, u16 idx, u64 desc_
>>          mvq->desc_addr = desc_area;
>>          mvq->device_addr = device_area;
>>          mvq->driver_addr = driver_area;
>> +       mvq->modified_fields |= MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_ADDRS;
>>          return 0;
>>   }
>>
>> diff --git a/include/linux/mlx5/mlx5_ifc_vdpa.h b/include/linux/mlx5/mlx5_ifc_vdpa.h
>> index b86d51a855f6..9594ac405740 100644
>> --- a/include/linux/mlx5/mlx5_ifc_vdpa.h
>> +++ b/include/linux/mlx5/mlx5_ifc_vdpa.h
>> @@ -145,6 +145,7 @@ enum {
>>          MLX5_VIRTQ_MODIFY_MASK_STATE                    = (u64)1 << 0,
>>          MLX5_VIRTQ_MODIFY_MASK_DIRTY_BITMAP_PARAMS      = (u64)1 << 3,
>>          MLX5_VIRTQ_MODIFY_MASK_DIRTY_BITMAP_DUMP_ENABLE = (u64)1 << 4,
>> +       MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_ADDRS           = (u64)1 << 6,
>>          MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY          = (u64)1 << 14,
>>   };
>>
>> --
>> 2.42.0
>>


