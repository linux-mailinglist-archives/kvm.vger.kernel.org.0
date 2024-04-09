Return-Path: <kvm+bounces-13939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EB7A489CF7B
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 02:35:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66BD81F23344
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 00:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC76B8460;
	Tue,  9 Apr 2024 00:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JO+AZy4B";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ssrdZRqy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499696138;
	Tue,  9 Apr 2024 00:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712622891; cv=fail; b=oc40zavAc42Jt5EFamqi/5XyYtOMPCcaLau96zyJqms3V9vShjOkV2Q3hZ2PSJbOv0um6A8V5JRchEUZAV19H6in0UgdSoRAmVBi/gQf+O5hxAYFqmgnz53KKssDRkHJwdJRSHY/2nz6Nl3MiMCrS/30t16n2K8ZG8UyQNpWRdg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712622891; c=relaxed/simple;
	bh=eq2LoJAeoY/60L4tHvzXDB5tTPwLzMSxymijiCJAJjY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DVPX0usWirQtI3NYovQt0SPjUcwBMhzWlk4taR4Rbo0CSRgvshAXNodWLiD6wO50M+CgV4SeOKa8I1WKT/+b8iM/3vFWCJMuhR0+qMW9SrZoxhkASCdket7Hgm0dACWd3KKLVJ3ZP0SADPRpP+TYn6l8aq5Syy+iOl4w2DDInU8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JO+AZy4B; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ssrdZRqy; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 438Ln9Bk010205;
	Tue, 9 Apr 2024 00:34:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=knJyJ6FXedvMzcMC0tjIL48c1AsTv3k7B/HqdHW9wgU=;
 b=JO+AZy4BxTLH0yV++lqTnjzKZe6eEsPiQq4xCBERl2lpqtN1Bk1JxWnAnqw7az2ZFyQH
 zRRxZkeun9+2m6gC7nJ0tbo/3zo2rd2Ga0JGTmoxtHPckKWc3LIWxevYtOxV+eyul4Qq
 RIeRcd+VZSafAGziZuBTPJUx35CKQoQxHvqkSd/gEvbpaX4C0MC0wrfJv4dRQ+n/qoT0
 uklPO9TS7jONpZN8t1vylgSPas5NvUKxC2V+iHQL4s9KQVAKauSaD2guaNyXWhP2sj2S
 SMDzaspvkXORmPv2j8KeJLwQCPv9umefEJ35kAxQZ69ApsZuLhpHSCEZzrggfhRMQk/S zg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xax9b3yb8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Apr 2024 00:34:19 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 438NBQD0019456;
	Tue, 9 Apr 2024 00:34:17 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xavuc72y1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Apr 2024 00:34:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f3c+wFiyP7T2Rc1PN2EqadgvbtZ3+EqXPnFV8XO1nPgduoedCoScK8/BT+aW408Dn3epMMscOQ9U7Lz1AfoMzS/4wvyam4GPayi3rqh8JdLQ/sLB6T+8vcCBaBrRPPqp9XDs/RJhv1RL/SNGStduCl0BEeyqCmcvNRAK7iBTLhV+k4ytEq1KRY0WzcCqg6T3USkVc2IX8h1xJOd57p2pu2OBCkltk9FtH+noIIXzAb9mU+6tgfM0KvsSZ5daf/OPnggCEyNCMcqByAnyity1KfW6pQZNqk1ALQR8oc77sdoe1MKYa4iWXogBQw8929l/snfKTwakNe4RUoQMvUctUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=knJyJ6FXedvMzcMC0tjIL48c1AsTv3k7B/HqdHW9wgU=;
 b=jJe9W7SAL8drCJYf2YcCesKRMYL6mJNPuVeKymth6qyQ5oVDMJl0SOZLda2igmETNa97YcltkqgplV/D16PM376Wb71fBSJxGqfZAK2SVNJH+8q9a9Vv6WwQGyisYqkukoRqL+TB5TwgZrPAxoy88I7KOd5Wqc41hX1RdoBr1v41AvjKhYpW4qe0CZaBPJHGnQ/xDxPJpt3d5EqsVn/pOtlE14ts61BmnVASwOncl610Ieazwig8so9oMthnfwvzvZDcvhMXRdM0/UEXBjNHqFLXUQ5a4bVahD8HAMjm5bhq7Gm9085BwJjlb/S/ZcQz3hrFnZgt0XPrapDaF9YhAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=knJyJ6FXedvMzcMC0tjIL48c1AsTv3k7B/HqdHW9wgU=;
 b=ssrdZRqyt2bZo7du6DM4N2DYt6dA3IK7iKxiQgszoZpZyOBBEYPrMJlvbDaloIx+amzmVDYetqzk4zqyeqeVXVmtzGNKR8E5yfyDtMlGQXPxPn9Bif16656ERqp0p0PWBtVBg/Mitm5dkZvruO6YEXTe5sw5QsEqpH9EhSJIRAY=
Received: from SA0PR10MB6425.namprd10.prod.outlook.com (2603:10b6:806:2c0::8)
 by SJ0PR10MB5669.namprd10.prod.outlook.com (2603:10b6:a03:3ec::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Tue, 9 Apr
 2024 00:34:15 +0000
Received: from SA0PR10MB6425.namprd10.prod.outlook.com
 ([fe80::894:70b7:573e:da46]) by SA0PR10MB6425.namprd10.prod.outlook.com
 ([fe80::894:70b7:573e:da46%5]) with mapi id 15.20.7409.042; Tue, 9 Apr 2024
 00:34:15 +0000
Message-ID: <1195c194-a2cc-6793-009c-376f091be7f0@oracle.com>
Date: Mon, 8 Apr 2024 17:34:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 1/2] KVM: x86: Add KVM_[GS]ET_CLOCK_GUEST for KVM clock
 drift fixup
To: Jack Allister <jalliste@amazon.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20240408220705.7637-1-jalliste@amazon.com>
 <20240408220705.7637-2-jalliste@amazon.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20240408220705.7637-2-jalliste@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH8PR15CA0001.namprd15.prod.outlook.com
 (2603:10b6:510:2d2::13) To SA0PR10MB6425.namprd10.prod.outlook.com
 (2603:10b6:806:2c0::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR10MB6425:EE_|SJ0PR10MB5669:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	qn2/xUUsvB7TQZrOP0Hy3xW/ZR9pUb+uKrGT52kWhtxL4HQYUas64WdyCTsKr8Mf2ANl1Xh9ykKhsaENDZ7UwqlxVy1QtO0LXo7NlwBM1AF5w/Dip2/j9E8syA5Buvbc/P3pvflBsROTEmzLK5L6LiDUrxMnG+ApNExQazXBnNvkoCTWCpC3cSdm6LLu1QerveZ4kPLhvqIUQ7D3eShGzhwFrB0Npyi3s98R+VdUuBSc2U13hC2LgCRd+UKVFTIv2kETLNGwXSJe2Gmvs6KrFECWxyomYGUf2Sp/TLmZmRvgblhiZxrOOiKlHbcXvpNbD//1agTYGE6zYR1PQ3/atdi7Qol9a/IqEXOTWrymLWv1HMQrGzgtAEfqmC8qZAGuofKaZjU8sXPWiNPqBG8nDkNTejrZDSIw79vtTgUp4FR1LI+nOVgReMvcJoKNgznz64L7KFmGQg1TLBPp8yQGLsNxZj6GclSdg8kNfPY8h4P/rtunT6dxIZEQnSU4knY/yE7o6wOuYET3N2PUejpTv1AlDEIAfRKmSK4w4m7Oly38Gl/fllN6WI4bW/weNzuxyem6z+LXEadxbvKXoXLZAQWILWmqh/Odns/U/ejqrj1ReO3M5AFt5HwGsjsungIr1KC4jHwg0CFMrMJ9Ngx66ck4vad6PMMwV+3eaHYYp7g=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR10MB6425.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007)(921011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Zk5ma1R3bHpPR2VuNXFGcVZxa0FoK21PNzFMYTBPaEhXYWtXUmRMTWc1Y0RJ?=
 =?utf-8?B?THdOWU5ubVpmM1B5OFVoSVpLcmVwUFRzTkswRGJ2YmNqYVorZmxjQ0luNklv?=
 =?utf-8?B?R1dEYWNkUHdjdUM4MkFXUXZ4UWk2Mm5Tazd3aXVMengvSTEvNHlmTVFaQkNS?=
 =?utf-8?B?YUhudzhBUTJsVE05bzMwWS8vQVJsZHNhamFyOUtKemVvMWhDZE5vVnlERzFO?=
 =?utf-8?B?blhOcFpHZ2hkK1I0RmVtWGw1RFRLRU9KZm0xNmhPNXZUaUcxdzYyOVpqRDVL?=
 =?utf-8?B?aUV0K21oa1JucXkyeHhpT014ODlYeWlVUjhNaWpKVDJ4ZEQvV1FFTGx0Q2s2?=
 =?utf-8?B?ZVZRNmhhbWVBclBNZmZzVlRGalM3RHZpYWh6R2lCVktQUGQ1QjZONGoyWWpC?=
 =?utf-8?B?RXkyb2lyZm9OYVRVTmV6VkNpVFlMeEZzZVhTTVl5RFJiNEpEa25hK0lEUTFH?=
 =?utf-8?B?eWthSy9TNjFuTDBrMEVTR0J5TkE2RnJlWmhjWVFJRk1YQSszWmtrZGpueDd5?=
 =?utf-8?B?UjZsYTBwMWx5ZEZkMkJQTTJxRmxDQ0dDWE5MUTRVQjRSK3ZoeGtkcXNiUVQr?=
 =?utf-8?B?S0VGSDlIZ1E5YUhIV3dXeHl4MEFaakd5OWdSZjBGaCtSZHhNdGhuQmpiVmxX?=
 =?utf-8?B?V3dYQ2k4SENVR0I3bVR1TVlKWUErbTlhcVR0R1VQZ0RrLzRKMHh1bllkWnFH?=
 =?utf-8?B?akpuNUNDdlhmcmxYb1VVU2s2TDhOaHJORTFIbllyMGhFQlR4OFQ3WkFReDVU?=
 =?utf-8?B?bWRZZzYwMUpTdmxWVzhPdS9pK3dCMklMQVVZZDhnNTAzdmQ2ajZrQ1JPWHly?=
 =?utf-8?B?OHZIY2JGTE5tekt5RVp2ZnlneUNwbHNyRXdyVUM0c1FqU3RkOGgrQkw5MXNj?=
 =?utf-8?B?cWZBOFlRT1J2Nmx1ZFlFVmE5TkRXdytxVkdOUHZHMk1qZ1crUS85MWxQOUhW?=
 =?utf-8?B?ZW04bDUwQkhEbEdmQmR1L0tMQ1U1ellsYWU4M2ZITTRsNmVsQmdtVURNRUlG?=
 =?utf-8?B?QjVVbE0yNCtNQXJvRzJKSXRveXJ1OVI3VnppL2o0amc2UTFRVkcvYmZHK0tX?=
 =?utf-8?B?K3NJNkF5emY0N09mRFV2UUxuTDY1OXZoNGF5WW9mT2FPcU5kb3IxT1dYUmF0?=
 =?utf-8?B?MU9uKy9VN0xlenI2Z21FZGQzS3lDM1AwZkVFU0E4V2dMVDB4a0xBOWltV1pj?=
 =?utf-8?B?c3VYNnJxdzFzYlBoS0ZNeHEvVEZ5RWZacnFTRjJZcmcwK3pFOHhjNHltY3J5?=
 =?utf-8?B?b3FueHprd0x1Y3RyMHBPR3hiZzN1VjNlME42eDA1NStGbGdPM0NKci9uYk8x?=
 =?utf-8?B?RlliQXVoMUQ0RmpMbnpVcE9BR0RaSkFtRE5FS05HUzR2L3FBZGFQQk0reUpU?=
 =?utf-8?B?Wm02TFBpUFlMUkxtcnJFODR5OWJWRUcwVWI1Z0ppQ3BSbGlCVXZYYkdNUmFk?=
 =?utf-8?B?ZjhoRlVCN3RpZFR4eVIwcDJUUHBhZ3g1aDZpdEZ6TC9KSEZDU1h1MDB1OHdS?=
 =?utf-8?B?a0U2Z0srK1pkVnBaZ1FPNW5YeWlrNlZDK0pTVm5pZlVUZ1JoWDNNYjFvQmhW?=
 =?utf-8?B?VFNXbjNjTmIwY2thNFpPTExzZkVmNjVoWkJnSnIyMVVkY0VzQnFIRnVQelVF?=
 =?utf-8?B?NEVpR1M1SW1FVWFibFltTVptNVVOZmM4Q0hzOUVtWjJkTTRIMHdobWtidmdR?=
 =?utf-8?B?bVg2cWJIUGpCQ2pGNkNSamFpQzRiUnNKMFY0NWJXWTlEejkvYlErb1AyM2dI?=
 =?utf-8?B?dWUwYjFzYkZ0Q3FtT05RQmRTUUx4VzBZRmUrbThoTXRGVkVaVjB1Mk9pVGNL?=
 =?utf-8?B?UUgwMzI0OFFtMHgzdmpHK2FndUt3M1NtZDNBZjJ2emJpbWFDVmMreVBTd240?=
 =?utf-8?B?R2dzYkt2OUh0NG9WclB5cExRUlc0SGV3TU13MmlTZStybVp0YVBldjQ5bElF?=
 =?utf-8?B?UWhvbjdNY3VaRVU3UnUrMlM4Q00wMDFNRXljMC9BVUpSclpzTkgxQTZrSzhz?=
 =?utf-8?B?dHpZcVpHcHJNeXJTZ1NFUm5QenNUckd2R1dtOGhBcy84bHlPS2JzSkNUUDIv?=
 =?utf-8?B?Uk84UGx6R0FEazl5MG0yN2pzQVJaU3JQakRsSi9SRUp4VnZnd2QvWm5ndy9Y?=
 =?utf-8?Q?eUY25JRS3/6ozHQdqN9e2ebq2?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	q+Ip0Yy5bDfIBct8ONQs/Dc7ftgOT7wUmafOjwc0Yi1KHLopsYsdH0LlfiFFMcejvUy8UPcsdGS+qM+Biv0dnH1QYgriD2X0l9fkyl8cDVlFaXGY0sqyN9gyIMMQJH/5Fyuv4+hps7KEULm+hK5edPVbnUYXDyRHtaPXduWoulDJktZ4lJJPSH0uFTWIIWetBF2cwx17St4Op27LKiyFm4hXg1+uaka6X+6xiF+WxMqz05gqKosrF5Pi/TZTXj52hI++VLsFSLVC9ZvVvdxxscGF59MEuRL9RjzZ6GtSfwKQm6uj7fqA+Pxyv2l5+c6hR2lORDZmGA6z4a3aRDwtxLHL0ywomriaDPSAzpS9mkzX2ci9C+bVTjY8Hazmler+DH8q3QiP9yfmLuPa/C3gwVwvWAThJQDSV5xjyh/1pqBcBXK3t5KSMOodPbkc4631gxveuGrEhUoncLU6d8+P02k94ouUmMrurbTWqYnT+adKRiExo1gnihxkV9LCXe53bJ/b1itI8uGCQJhYv+XhmWuN3YfPzpFk0YIaRCaZtyddxPjYRQaQcXTv81lJXWiw4Vl6RIn9q5pxPAeCr+I6UCpKb9nwh88dFSZIvRj0XEM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13217af3-4df2-4a7b-2e53-08dc582cc8be
X-MS-Exchange-CrossTenant-AuthSource: SA0PR10MB6425.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2024 00:34:15.1017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +9/K87yj4k55UwL9SYEOR5KOq/ojG77tB1ftE3vUpgyz3pzywFFXshp6ChdJAv7I55iZuNiUw2EBA3KBa0OREQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5669
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-08_18,2024-04-05_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404090000
X-Proofpoint-GUID: i_VunuQSNxQK2VCCWIPZ7y-SRfp0EsaP
X-Proofpoint-ORIG-GUID: i_VunuQSNxQK2VCCWIPZ7y-SRfp0EsaP

Hi Jack,

On 4/8/24 15:07, Jack Allister wrote:
> There is a potential for drift between the TSC and a KVM/PV clock when the
> guest TSC is scaled (as seen previously in [1]). Which fixed drift between
> timers over the lifetime of a VM.

Those patches mentioned "TSC scaling" mutiple times. Is it a necessary to
reproduce this issue? I do not think it is necessary. The tsc scaling may speed
up the drift, but not the root cause.

How about to cite the below patch as the beginning. The below patch only
*avoids* KVM_REQ_MASTERCLOCK_UPDATE in some situations, but never solve the
problem when KVM_REQ_MASTERCLOCK_UPDATE is triggered ... therefore we need this
patchset ...

KVM: x86: Don't unnecessarily force masterclock update on vCPU hotplug
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c52ffadc65e28ab461fd055e9991e8d8106a0056

I think this patch is only closely related to KVM_REQ_MASTERCLOCK_UPDATE, not
TSC scaling.

> 
> However, there is another factor which will cause a drift. In a situation
> such as a kexec/live-update of the kernel or a live-migration of a VM the
> PV clock information is recalculated by KVM (KVM_REQ_MASTERCLOCK_UPDATE).
> This update samples a new system_time & tsc_timestamp to be used in the
> structure.
> 
> For example, when a guest is running with a TSC frequency of 1.5GHz but the
> host frequency is 3.0GHz upon an update of the PV time information a delta
> of ~3500ns is observed between the TSC and the KVM/PV clock. There is no
> reason why a fixup creating an accuracy of ±1ns cannot be achieved.

Same as above. I think the key is to explain the issue when
KVM_REQ_MASTERCLOCK_UPDATE is triggered, not to emphasize the TSC scaling.
Please correct me if I am wrong.

> 
> Additional interfaces are added to retrieve & fixup the PV time information
> when a VMM may believe is appropriate (deserialization after live-update/
> migration). KVM_GET_CLOCK_GUEST can be used for the VMM to retrieve the
> currently used PV time information and then when the VMM believes a drift
> may occur can then instruct KVM to perform a correction via the setter
> KVM_SET_CLOCK_GUEST.
> 
> The KVM_SET_CLOCK_GUEST ioctl works under the following premise. The host
> TSC & kernel timstamp are sampled at a singular point in time. Using the

Typo: "timstamp"

> already known scaling/offset for L1 the guest TSC is then derived from this

I assume you meant to derive guest TSC from TSC offset/scaling, not to derive
kvmclock. What does "TSC & kernel timstamp" mean?

> information.
> 
> From here two PV time information structures are created, one which is the
> original time information structure prior to whatever may have caused a PV
> clock re-calculation (live-update/migration). The second is then using the
> singular point in time sampled just prior. An individual KVM/PV clock for
> each of the PV time information structures using the singular guest TSC.
> 
> A delta is then determined between the two calculated PV times, which is
> then used as a correction offset added onto the kvmclock_offset for the VM.
> 
> [1]: https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=451a707813ae__;!!ACWV5N9M2RV99hQ!OnMXeXj4Plz6xvAc5lYsKaR3d1GDGGGRhZkdLMbxr8Skc_VAv_O1H8qP9igQv4KPCtYDw2ShTUtEd2o3mD5R$ 
> 
> Suggested-by: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Jack Allister <jalliste@amazon.com>
> CC: Paul Durrant <paul@xen.org>
> ---
>  Documentation/virt/kvm/api.rst | 43 +++++++++++++++++
>  arch/x86/kvm/x86.c             | 87 ++++++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h       |  3 ++
>  3 files changed, 133 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 0b5a33ee71ee..5f74d8ac1002 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6352,6 +6352,49 @@ a single guest_memfd file, but the bound ranges must not overlap).
>  
>  See KVM_SET_USER_MEMORY_REGION2 for additional details.
>  
> +4.143 KVM_GET_CLOCK_GUEST
> +----------------------------
> +
> +:Capability: none
> +:Architectures: x86
> +:Type: vm ioctl
> +:Parameters: struct pvclock_vcpu_time_info (out)
> +:Returns: 0 on success, <0 on error
> +
> +Retrieves the current time information structure used for KVM/PV clocks.
> +On x86 a PV clock is derived from the current TSC and is then scaled based
> +upon the a specified multiplier and shift. The result of this is then added
> +to a system time.

Typo: "the a".

> +
> +The guest needs a way to determine the system time, multiplier and shift. This
> +can be done by multiple ways, for KVM guests this can be via an MSR write to
> +MSR_KVM_SYSTEM_TIME / MSR_KVM_SYSTEM_TIME_NEW which defines the guest physical
> +address KVM shall put the structure. On Xen guests this can be found in the Xen
> +vcpu_info.
> +
> +This is structure is useful information for a VMM to also know when taking into
> +account potential timer drift on live-update/migration.
> +
> +4.144 KVM_SET_CLOCK_GUEST
> +----------------------------
> +
> +:Capability: none
> +:Architectures: x86
> +:Type: vm ioctl
> +:Parameters: struct pvclock_vcpu_time_info (in)
> +:Returns: 0 on success, <0 on error
> +
> +Triggers KVM to perform a correction of the KVM/PV clock structure based upon a
> +known prior PV clock structure (see KVM_GET_CLOCK_GUEST).
> +
> +If a VM is utilizing TSC scaling there is a potential for a drift between the
> +KVM/PV clock and the TSC itself. This is due to the loss of precision when
> +performing a multiply and shift rather than divide for the TSC.
> +
> +To perform the correction a delta is calculated between the original time info
> +(which is assumed correct) at a singular point in time X. The KVM clock offset
> +is then offset by this delta.
> +
>  5. The kvm_run structure
>  ========================
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 47d9f03b7778..5d2e10cd1c30 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6988,6 +6988,87 @@ static int kvm_vm_ioctl_set_clock(struct kvm *kvm, void __user *argp)
>  	return 0;
>  }
>  
> +static struct kvm_vcpu *kvm_get_bsp_vcpu(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu = NULL;
> +	int i;
> +
> +	for (i = 0; i < KVM_MAX_VCPUS; i++) {
> +		vcpu = kvm_get_vcpu_by_id(kvm, i);
> +		if (!vcpu)
> +			continue;
> +
> +		if (kvm_vcpu_is_reset_bsp(vcpu))
> +			break;
> +	}
> +
> +	return vcpu;
> +}

Would the above rely not only on TSC clocksource, but also
ka->use_master_clock==true?

 3125         ka->use_master_clock = host_tsc_clocksource && vcpus_matched
 3126                                 && !ka->backwards_tsc_observed
 3127                                 && !ka->boot_vcpu_runs_old_kvmclock;

Should the condition of (ka->use_master_clock==true) be checked in the ioctl?

> +
> +static int kvm_vm_ioctl_get_clock_guest(struct kvm *kvm, void __user *argp)
> +{
> +	struct kvm_vcpu *vcpu;
> +
> +	vcpu = kvm_get_bsp_vcpu(kvm);
> +	if (!vcpu)
> +		return -EINVAL;
> +
> +	if (!vcpu->arch.hv_clock.tsc_timestamp || !vcpu->arch.hv_clock.system_time)
> +		return -EIO;
> +
> +	if (copy_to_user(argp, &vcpu->arch.hv_clock, sizeof(vcpu->arch.hv_clock)))
> +		return -EFAULT;

What will happen if the vCPU=0 (e.g., BSP) thread is racing with here to update
the vcpu->arch.hv_clock?

It is a good idea to making assumption from the VMM (e.g., QEMU) side?

> +
> +	return 0;
> +}
> +
> +static int kvm_vm_ioctl_set_clock_guest(struct kvm *kvm, void __user *argp)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct pvclock_vcpu_time_info orig_pvti;
> +	struct pvclock_vcpu_time_info dummy_pvti;
> +	int64_t kernel_ns;
> +	uint64_t host_tsc, guest_tsc;
> +	uint64_t clock_orig, clock_dummy;
> +	int64_t correction;
> +	unsigned long i;

Please ignore me if there is not any chance to make the above (and other places
in the patchset) to honor reverse xmas tree style.

> +
> +	vcpu = kvm_get_bsp_vcpu(kvm);
> +	if (!vcpu)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&orig_pvti, argp, sizeof(orig_pvti)))
> +		return -EFAULT;
> +
> +	/*
> +	 * Sample the kernel time and host TSC at a singular point.
> +	 * We then calculate the guest TSC using this exact point in time,
> +	 * From here we can then determine the delta using the
> +	 * PV time info requested from the user and what we currently have
> +	 * using the fixed point in time. This delta is then used as a
> +	 * correction factor to fixup the potential drift.
> +	 */
> +	if (!kvm_get_time_and_clockread(&kernel_ns, &host_tsc))
> +		return -EFAULT;
> +
> +	guest_tsc = kvm_read_l1_tsc(vcpu, host_tsc);
> +
> +	dummy_pvti = orig_pvti;
> +	dummy_pvti.tsc_timestamp = guest_tsc;
> +	dummy_pvti.system_time = kernel_ns + kvm->arch.kvmclock_offset;
> +
> +	clock_orig = __pvclock_read_cycles(&orig_pvti, guest_tsc);
> +	clock_dummy = __pvclock_read_cycles(&dummy_pvti, guest_tsc);
> +
> +	correction = clock_orig - clock_dummy;
> +	kvm->arch.kvmclock_offset += correction;

I am not sure if it is a good idea to rely on userspace VMM to decide the good
timepoint to issue the ioctl, without assuming any racing.

In addition to live migration, can the user call this API any time during the VM
is running (to fix the clock drift)? Therefore, any requirement to protect the
update of kvmclock_offset from racing?


Thank you very much!

Dongli Zhang


> +
> +	kvm_for_each_vcpu(i, vcpu, kvm)
> +		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
> +
> +	return 0;
> +}
> +
>  int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>  {
>  	struct kvm *kvm = filp->private_data;
> @@ -7246,6 +7327,12 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>  	case KVM_GET_CLOCK:
>  		r = kvm_vm_ioctl_get_clock(kvm, argp);
>  		break;
> +	case KVM_SET_CLOCK_GUEST:
> +		r = kvm_vm_ioctl_set_clock_guest(kvm, argp);
> +		break;
> +	case KVM_GET_CLOCK_GUEST:
> +		r = kvm_vm_ioctl_get_clock_guest(kvm, argp);
> +		break;
>  	case KVM_SET_TSC_KHZ: {
>  		u32 user_tsc_khz;
>  
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 2190adbe3002..0d306311e4d6 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1548,4 +1548,7 @@ struct kvm_create_guest_memfd {
>  	__u64 reserved[6];
>  };
>  
> +#define KVM_SET_CLOCK_GUEST       _IOW(KVMIO,  0xd5, struct pvclock_vcpu_time_info)
> +#define KVM_GET_CLOCK_GUEST       _IOR(KVMIO,  0xd6, struct pvclock_vcpu_time_info)
> +
>  #endif /* __LINUX_KVM_H */

