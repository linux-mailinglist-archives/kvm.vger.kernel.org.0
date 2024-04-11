Return-Path: <kvm+bounces-14222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F0268A0A84
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 09:50:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 065A92831D2
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 07:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B896E13E8A7;
	Thu, 11 Apr 2024 07:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m9zO0Ne8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="b4m1TYN5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1FC13E40C;
	Thu, 11 Apr 2024 07:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712821830; cv=fail; b=F4rs0gSxJsPRuohHOyI3VgWe/No8dqr859Ol32qaq7ysDy7ZMxpVt+3lez05wmjTpqhtTESNXYx9KDiRrFH6nPZ6tgdIV9lDA2zXAW8vJk0qYbkF7SMT0trBqNnKevJSHgmjeJU1zQtdm5HWFTR0wAvZMi6T48Ojo4NLI9PFZzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712821830; c=relaxed/simple;
	bh=GKyeq/IgxoEpdg6nV3rj6wyxWzM+yJtSzZNj3UWHmoI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bH4PLMblOrNw6IRsqwC0PS5LEn+VOIsYwkz3l4hTUxnmSg8jLnoSLGLlaxhDHc396v87Culg64uqaKUCfcKqschDf1ygULEinvbO7TH+HfhWmq/xUF96EH/MsUidZwnb37GwqLdjAY1txO9Knl67Q2vhYCWqoBAY5MIQ729Ace0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m9zO0Ne8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=b4m1TYN5; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43B6X7ad003246;
	Thu, 11 Apr 2024 07:50:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=HkRxOPNfJ/wEZ60+NJf10KQ4APE9e5jw2InopIkasW4=;
 b=m9zO0Ne8HPWmxRaYKRIpbuQsmjdgQfcNWVUgDdE/F+x+lc1szylUM1HgBzSkOZmGkPwR
 Dg/0McnTZ3OsghyRtQ972IlLdEXLWMqI15GGy2sVDi8TQKXHNJrynl7n05q8Fy+VoLjB
 Thxmd66c02O6kbtV+F8bt83AmXoRwHVvGBSqaSpdx0+WoI5DmZIV7IgeDWpHxVWWtbh+
 o7u5KOYXh8ZDzZ0SGIhph/xmv2iGXHzw1vk0t/5PBfPS/lXViozRR5RgL3WGOXpUSQIe
 MSgy+YP/c7xTaBCvtzAch52mOoyyLg1C4x8MDZt95GryiG4Jppz+hzvc6K8J/CPJCZtl wg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xaxeds478-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 07:50:04 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43B5lNLS007881;
	Thu, 11 Apr 2024 07:50:03 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavu979ya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 07:50:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WnIP2JWWQa2XSGhRPYcimXt+i4gH9Rxuh+UfOt77aG4SA/AEZFjL78MM81Ffp8POwb8s+uznDIPEV/kFnwTGbLXGbtVAkSPpKDjXx2hRzBbgDSIIfosfUGnejDCu5s8xQzF7tnXVLELWr6DCLG1Kn2sMyi7YDsQRHJ1gI+rweI9YZOpcx6EWahzsGD6ZBExsfal0qLKA6LDpX+6KEFVg/hXP49KfTmBtJXLn/Sv8sRhA6ISjWzZ7q+bLR/SJW7VGCiCmMGhMphXFoFVhQG1Hjh/6TdtaVKToIlB4exnyp+3rUCwnUjvJdTGqFuX0SfLvFKjuo7reDEXt8GvEWzYOog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HkRxOPNfJ/wEZ60+NJf10KQ4APE9e5jw2InopIkasW4=;
 b=aL7aZ2G1lH6glo8fggxtuW/vOAT0GOxEXaoqz93D2BRMcHb3e1PiIstyPcoRPGxQ9eNZwjsOuuWZwV/MsMEhsMWvd9hkemjaFcaldB4RzGZoVD6f6kilPERWoTBqKowV4djYRbzI2J6Hao88m5NaKSmHdm5e0nQIq3/q5yc6glSaMQEqumWf6OV45e4eNoquCnUQaYcGSzPSUpF8ZattMhWYbkeOf5bXkbpcQmxJGHT8oLtUrSvZYkOumofxRxq/cHcY2N9EVqUHrNAfo6IOMnRo2LzbASkYHR3G9n0NH+kBC7bxRZQ42SJEvjJXXi6DUrk6QZfGf2MdD4wx5LWi4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HkRxOPNfJ/wEZ60+NJf10KQ4APE9e5jw2InopIkasW4=;
 b=b4m1TYN57qcPecrZscZHXwIRiOfdMsVl8ouzyoqrqsCSlhUolTQwUAPEt9OC8Dv7gUSPaOPeZNVauR1vgyIfNn++RH4CFoCAxDpNA72INRJJln4/GVnVSGXG1z4fBlVQm2evlKt34NbDYjdZuDMOX2wr/qrQ+SIgWY11ZCscoME=
Received: from SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18)
 by CH0PR10MB7536.namprd10.prod.outlook.com (2603:10b6:610:184::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Thu, 11 Apr
 2024 07:50:01 +0000
Received: from SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::1481:809a:af18:ac44]) by SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::1481:809a:af18:ac44%5]) with mapi id 15.20.7409.053; Thu, 11 Apr 2024
 07:50:01 +0000
Message-ID: <d248fdfb-e89d-409f-97f6-5ded84a5b495@oracle.com>
Date: Thu, 11 Apr 2024 09:49:55 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Set BHI_NO in guest when host is not affected
 by BHI
Content-Language: en-US
To: Nikolay Borisov <nik.borisov@suse.com>, x86@kernel.org,
        kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, daniel.sneddon@linux.intel.com,
        pawan.kumar.gupta@linux.intel.com, tglx@linutronix.de,
        konrad.wilk@oracle.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, seanjc@google.com,
        andrew.cooper3@citrix.com, dave.hansen@linux.intel.com,
        kpsingh@kernel.org, longman@redhat.com, bp@alien8.de,
        pbonzini@redhat.com, alexandre.chartre@oracle.com
References: <20240411072445.522731-1-alexandre.chartre@oracle.com>
 <18b29bd6-5eb5-4344-b80f-f6a55c18b8ba@suse.com>
From: Alexandre Chartre <alexandre.chartre@oracle.com>
Autocrypt: addr=alexandre.chartre@oracle.com; keydata=
 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
 swLliy6PdpST
In-Reply-To: <18b29bd6-5eb5-4344-b80f-f6a55c18b8ba@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0184.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::10) To SN4PR10MB5622.namprd10.prod.outlook.com
 (2603:10b6:806:209::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN4PR10MB5622:EE_|CH0PR10MB7536:EE_
X-MS-Office365-Filtering-Correlation-Id: 580462a8-f8cc-4830-ea79-08dc59fbfdd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	clk7PfPrhQd8dOJzPCEazfB/T9wFS5jBLp6K56t2VytoCHbC6rL8B33n+4rGql7LWE0Crfm9CWKbmZwTdHytp3Qw+N4A6DMlv9k0HVLIFfAqStj7cIjU3/sNz5mpd+5NSJwJj858C6Jqjh6mjLr6I2MJCfs2NgIDS8SiS1kvo1u0o5rAqiRa4RJavTnfgQZiezyuarNCusNHy5iL1cSjbwd4gZwY/LU2lEKkWL1pGCLHHEMV1ZqbkNuh21qTiAP00nqY5TG9UiEp0CKVNYVaxQFJKzn+hrEfXCrbDb6w/1IbXk59ALoHHwJ9aK8eYr8Dz0McTf3ocOtZemNFJTDS0KbYJcLcAxF33SqjWenuArqoOyfLENfnyZbbR/WqdOCDgUOgSC7dF5GqMI0OVzVIC0ZbjUe79Dpuv99JqRIxAK/j84zzxLbNFX3VNuNFGhuG33NgI60NcL1oSzW8mjZ/bcSXEbJXwDgh0v7E06jW171n2bLTgbE2Xbu+Z5PWA9OTwkBYP0ySvySyV/aUOg8NIjAJKgGU/382869BTWLUry5xiAQpoceKz0ooID3svpzqk7uw45udlDweVVq+NDXXH22QBKkkvow2CZ0vMEARObZ4p0pSASt+npAJoeY1ocpexYzZRT3QYzvFZo+2P9BzSobz9fa3J+z6PrGv7taLDzY=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR10MB5622.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?SkdpcGREYytrZDNaQUdJWUJDZ1ZuZ29EelNDMWV1amVpUHhLTTVQK0VwV3BI?=
 =?utf-8?B?cTV2SURMSjRvZk5WTGJlcUxJT1JQMWRhdTUzVHVxMFovU2kvZ3F4djdET1Fx?=
 =?utf-8?B?aVBOOFpPNnVJMDVmL0xCMzd0VlYwc1I4TWFnUUZ3emtNYkVDbWZsem01ODZK?=
 =?utf-8?B?TTVhb2pvSEF6SDRkcTVEYWF0OGJtMncvVitFdXUzbnBNR1grUFRmT1JzWWlw?=
 =?utf-8?B?dHdjUzhvWWhNK21Ba3BVTEJUY2JpNVE5VktQamhOS2lkdGxlTm5iL3hCMWhN?=
 =?utf-8?B?RjVUR0UxSjZuKzVyR04rSVUvWVQ1eUp0aG9paGFXdkpUUFIvdFlPdUo0ZUU5?=
 =?utf-8?B?dkI2SjRqYXhNL3BkZGJDc1dDZW14M1hmbS9mbW5pSmd1dzhVaFdabTNxekM5?=
 =?utf-8?B?ZWxzZUptandjdFo5ZnA4MFlkd0JPNENsMmw4RkhmNGo4MTFMT3R6RWx3amEv?=
 =?utf-8?B?aEdSQ0NrbWR6TzBmQUVuM0NLWHVsYXJHZ1h4MW9TdnJ3V3RTeC9zOUt2d1k3?=
 =?utf-8?B?ZFJGaGR3dkFrTkVWMEg1VUYvN2Q3SGhIdENMS3Nhamp2Z0dRbS9XQVZQbHNj?=
 =?utf-8?B?Z1lQQ2xrMXRLL0tKKzBqTGZEYUlDekQydWVUNWFET3l1SERSQ1lsc1hmRnRB?=
 =?utf-8?B?ZkpnQWozdWJNREZEdTZkRFBsektzMFFzQmhMcW1NdlBuQU5qSjN0Q1RGaEZz?=
 =?utf-8?B?cGt0Snh1VjVzN2lXaGVGN2w0K0ZhOS95TDRYTXRIOHorTFhTdExhYndFbm9P?=
 =?utf-8?B?QVJkWkZScWJFSUhyV2l3c1NpRi80YjZqQVZQRTN1SWpYWmxoWW5Oc0ExQkVZ?=
 =?utf-8?B?eURGdUdrRStVT1ZXaUVUaCtxTncyU0Jmdm04cm56NFRnLyttbm9tMUdEY3ow?=
 =?utf-8?B?NDgxT1BTTE1jRTFRamltTklyM2VrbWJySFpINVkwTG1zbG0xY3lMbVlnVmZH?=
 =?utf-8?B?Qm9SaHBsV09ka1VjVHpzUS9iM2NGODQzMGFJak5TYlYrNVI1ekxMSVgxZWtI?=
 =?utf-8?B?YU91ZVVKZSt4YXdiSlV0NENXZ0w2QkFUbnc0OE1QQXBkUStEUDcyNUt0OGNx?=
 =?utf-8?B?OVhnSkFMdnBjQ3ZhUXlUZHVmcEZKRHhHMVcyb1RPUlpYczcwejFYZnh3ekZp?=
 =?utf-8?B?SWhqSUhWN3ovaHZ6elFmeXRZSWNLRHFqSGl2L3JsTWpMbXJSRlJhZWMzb1R4?=
 =?utf-8?B?dllRTWRmQ3E3SHFoSFhXU25FMDZGZSt6cHpiemlVOUpFZjBCZDY1Q1VZSnIz?=
 =?utf-8?B?MHVQenRaRmQ2WUFReFR1a2gwZGk1Yzc4U3MxS3h6RVQvaVRGQThmVFcrQ2pk?=
 =?utf-8?B?S3VXVTZ3dTNpVVEralZWeFZJQzN3WTFyMHE2WGJkUUQ1eThGSk1nRWl1Znhw?=
 =?utf-8?B?VGJwejFvOGdscVBjV2srRG5wTjJaZUQyeDRicTdUQW50d3dMTTNQLzk4dzlJ?=
 =?utf-8?B?UVdCV3ozWTYxNjY4RTlLM0hpZnRtdEsvQmtEWGMxZ0UyVnh4N3RhNEd2V1E5?=
 =?utf-8?B?V1lkdUFNVDRWUEtrZVlwa3dGUjU0UjllMUI2YnNMd2NoWE5TejExWFUyaWQr?=
 =?utf-8?B?WHdqQnowd09oZHAwWXdwUzgzR096NlJ3V0prL2kvaUlIOUNnYVhLZU1YV0RB?=
 =?utf-8?B?Vk11SW9IQk5KejMyeUJaVU9vSnIxMW9lYjBsdzV5TWZ5VnUxM21LZHN4TkQz?=
 =?utf-8?B?U29mY2NIK0J1V3VrR3M0TW9iSWY4RFJGcG9XMFVRV2RQTWtOUlBCcFVFU2RZ?=
 =?utf-8?B?cFgrcTNZenhRWEhWNHJqajhEUDVZNWpDV20vaGlHTVZsOEVzTGdMNU81TUZX?=
 =?utf-8?B?UTFwd1F1NmowQjJTb0tab1JCUU5JUVJ5TDREc2RobVJGNUUzWjdJa3JRWUU1?=
 =?utf-8?B?VmRSaFFnemJpM0NEbjJxSEhBbUMvWXJHNVdVZ0lnU3FxMEZUYkNyN1JKSU9F?=
 =?utf-8?B?SEpXQ0pZRGY0YXRpbGVxaGFuWWZIMkd3ODNvb21CQmV0Mkl0ZEJmc3NGcDdq?=
 =?utf-8?B?VUxpT1Z2Z2NwaUxWTHZqaDhvbFI2bkdXaEtEYkx0Q1FvZkN4Q0hyK1phVHpK?=
 =?utf-8?B?NXhHRCtlS2d6MU5oMGF5SUc1K3Z1UGJ4SHFoUnFSQkE2V2E5WlRaYmxDdERV?=
 =?utf-8?B?a09oU2xsWWJySDlIckwzQ0ovTTNxTlZxSU81WDVGY3ZETENUMTFwVCs0ZEs2?=
 =?utf-8?B?MlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	kAhXTOVwk0AubZhPw3int5w+JFQYJhSpTgI/795sZibaXv/3WG7vMXb7MqQLS7QYPjgORouAaTnQd84+Cn7jDCzvKW6BTJhsJFG8l+QFxYtrU8rrhEUkhfVfg89R9DG3Z7hGVelPEnjjlNe3pKCCytGUxfMf+ddF/BY7qGMJPXF2w/tNJ/+MlZjiv52EPSPws7t4XET2UI30KWcY4fapDjfMSQL3zjkT7nHG7pqzz33XyzLC39lR/pKJu9mATt4b/THXwxQ4k8lBv+G0sj0TK6KANTEZNFaEZG5iq47uOpp4a1o04tpsUXmC7np0A7UevufEWydDM2azdXGxTaGbg/3HLJLsyhp6ydtbUHvHSonqgUd8VxHHpxrT5PpXDPOBNo96vwVSAjEnQf8T9P21q/Zh4xnomwZPSriJ3EaxKv7fiUo36tFODQ9XhyxRwzd06/ewpCil7DGxqyacIzeERzFqWUsZ3nTJziXOUR7rhzhor3cRVzBdi3+aHr84+JAVsQoWXwACZ5WPIn9VRkpYpNhD23kUvenO0UY+eCgfUOuqk9GERJ9ppkmlAA8rZy0wiL7Jt9YFsppJDIGlqG0xyUsk11Vq6B6iapkDftCcnA8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 580462a8-f8cc-4830-ea79-08dc59fbfdd5
X-MS-Exchange-CrossTenant-AuthSource: SN4PR10MB5622.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2024 07:50:01.3112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fpd8ZWaT6NpKG03l3d3nmzz+80drvK1fPZPP3Gd92RwRUN0XD0YH80Co7/aapLjh8b08M3cpOMI7H5VPq/UXP3jyTT1FiLAFnIP7eU0RLUE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7536
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-11_02,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 bulkscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404110055
X-Proofpoint-GUID: oYK0ZR64D_1jBCchEWb797W8oXUAsfSc
X-Proofpoint-ORIG-GUID: oYK0ZR64D_1jBCchEWb797W8oXUAsfSc


On 4/11/24 09:34, Nikolay Borisov wrote:
> 
> 
> On 11.04.24 г. 10:24 ч., Alexandre Chartre wrote:
>> When a system is not affected by the BHI bug then KVM should
>> configure guests with BHI_NO to ensure they won't enable any
>> BHI mitigation.
>>
>> Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
>> ---
>>   arch/x86/kvm/x86.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 984ea2089efc..f43d3c15a6b7 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1678,6 +1678,9 @@ static u64 kvm_get_arch_capabilities(void)
>>       if (!boot_cpu_has_bug(X86_BUG_GDS) || gds_ucode_mitigated())
>>           data |= ARCH_CAP_GDS_NO;
>> +    if (!boot_cpu_has_bug(X86_BUG_BHI))
>> +        data |= ARCH_CAP_BHI_NO;
>> +
> 
> But this is already handled since ARCH_CAP_BHI_NO is added to
> KVM_SUPPORTED_ARCH_CAP so when the host caps are read that bit is
> going to be set there, if it's set for the physical cpu of course.

Correct, if the host has ARCH_CAP_BHI_NO then it will be propagated to the
guest. But the host might not have ARCH_CAP_BHI_NO set and not be affected
by BHI.

That's the case for example of Skylake servers: they don't have ARCH_CAP_BHI_NO,
but they are not affected by BHI because they don't have eIBRS. However, a guest
will think it is affected because it doesn't know if eIBRS is present on the
system (because virtualization can hide it).

I tested on Skylake:

Without the patch, both host and guest are running 6.9.0-rc3, then BHI mitigations are:

- Host:  BHI: Not affected
- Guest: BHI: SW loop, KVM: SW loop

=> so guest enables BHI SW loop mitigation although host doesn't need mitigation.

With the patch on the host, guest still running 6.9.0-rc3, then BHI mitigations are:

- Host:  BHI: Not affected
- Guest: BHI: Not affected

=> now guest doesn't enable BHI mitigation, like the host.

Thanks,

alex.

