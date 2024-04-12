Return-Path: <kvm+bounces-14548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E31C8A33F3
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 18:40:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F94B1C21DD6
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 16:40:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54ECD14AD31;
	Fri, 12 Apr 2024 16:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dADOEYgw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="z6yfVk5e"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9740C84A35;
	Fri, 12 Apr 2024 16:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712939994; cv=fail; b=tHhZbaO+l1zdONdCBx3UOdrnPVp9CbvY/F42pthqu7CJ5QCuTIB0hZ5ILSowgsfCHP31PBBkOP/UsEKCxsEgejWS6s44CIq8e10sye/CsFq46sDND4YRZWzMGtv9erEZE+LwyvMnLYzl7VOKeDdKdAQ0WAF1HNpHLifCMNWXA0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712939994; c=relaxed/simple;
	bh=7GkYE01a8jx+T8L3FTPdPwGcFQX0jQWlQ2VqNWTpryY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CcltUZ/q079+GgT21zl7ccSvldhUAclWZS0B1GAoCt89vCW/oEiZKG7L8IaCChvZR5tEfZNxn6I0J5qnhf2Ht9ILpwh+dVkAt8EVqCt0K3EGYv30IkqGwOeWu4MrMoNkSLYp5qo0w3einE0BAIKHE97nkm+Ht7gK/lyGQx+03jo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dADOEYgw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=z6yfVk5e; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43CGd8hA008146;
	Fri, 12 Apr 2024 16:39:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2023-11-20;
 bh=0EG9MHWlk+rqBe0f52RNw+0UA4XWXUyXp69oCyOtPqU=;
 b=dADOEYgw1oQ24vIdnBqzWA72akjMFsLDlD29Y7wRj7sPaOxHw61TCjlB8EEb12jsbY0u
 uqiyVvS+cYwCrhsricQWgqc426eyjYvijIBEmqQjxBIyDsciWibl+73cX/J5lctjGWkK
 1BRIltq2K+pkmPUz2Qp1dcoUUGeddOjJob5OVwQeQrjxzeu/E2SP/1X9sf0RDpGNLvPb
 bGXzuqyga/IhRSQeTwz9r8441VGL3k5PRzc5zYk8qyK10BNMhv2Holx9EhGUjhtzubjC
 pCwMAAsnFxtMlSSa2bIU6RpIQvGNVaoGGLo0sD4roxUnREt7hY4cOsE/6UFerxQ72CDX Nw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xax9bc1k5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Apr 2024 16:39:10 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43CGBwW1032535;
	Fri, 12 Apr 2024 16:34:21 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavubwxj0-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Apr 2024 16:34:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b5ZA3tETEFhJvRdIFZvwC6k8XqkF7H3kguMmJWk20T7pabNnDJ97t0QYHnP7rhhUCaxcq1q4mtpzo3wOnDeq0yNfxL8ctFHzfqNKSTF/noFilu4fIJPYnPWVD4R1nQDbbRNF82xtNz5Z2zmVT7LwLBmqt6f3DUhhmwEre4JBo5noyvPfDBCFW6z415chDPyS5sFVkQ/Dhw/IzRgObaitzubn5l/WcXQvlT5BvbOCsRrxxvAehEkp8oF3TJtez63WxZRKYMOOCNgF+0CKIRas/7TE4CXZ8hWiZUkpZVtJnUnJulUSjYGNj+L8jxwc3lgs4KFIeeyAhJpvZK8LEMcW8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0EG9MHWlk+rqBe0f52RNw+0UA4XWXUyXp69oCyOtPqU=;
 b=jj9w+PSLhzSWXDm5353fNhFHnh1WVxYmsUFw5bNIufp0xpeIAJaN0vR9e7S62JU7p53laWHmT3y5/Mha//VkZHjnmrW4OjeXzhSKNtZhWRruX309Iz1w7yivQ/ylYtLkXBvWcc84b4MjmRgbDIgI2XWzqSthKN+PBwGVSJPOR7b9reIAkv9fXiyq4Nyb/dy1Z3g4SLU9k7A+4dGfsyc3k6BZKS5FXMULZUH7EsDioEaFho4K/ZBL5Lx0Qavpu5y/3/cXA+h7cO3Aarvd3+c1wvowjdmia7WC7ubCTnIxK30shrvRQVi5kfBbONEc8/OiCG/cwS5ryivxd/qAHFAgmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0EG9MHWlk+rqBe0f52RNw+0UA4XWXUyXp69oCyOtPqU=;
 b=z6yfVk5ePcJwrLFh7b/G7dTUbTl25/YNvfmx2DZOR+WhPtgp3TLPTkXQFwH6BvNxegFdWGaKsA9HsAg1RgpbYSaT5hh0hfYTipe2NqttXirdgSzgu4JaunGItYtkrSHKWhYlUvMKZQpHqHVMuyg0QJxFPxJvBhR6YFz8AJk0gT4=
Received: from DM4PR10MB6719.namprd10.prod.outlook.com (2603:10b6:8:111::19)
 by MW5PR10MB5713.namprd10.prod.outlook.com (2603:10b6:303:19a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.55; Fri, 12 Apr
 2024 16:34:06 +0000
Received: from DM4PR10MB6719.namprd10.prod.outlook.com
 ([fe80::4581:e656:3f19:5977]) by DM4PR10MB6719.namprd10.prod.outlook.com
 ([fe80::4581:e656:3f19:5977%7]) with mapi id 15.20.7409.042; Fri, 12 Apr 2024
 16:34:06 +0000
Date: Fri, 12 Apr 2024 12:33:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniel.sneddon@linux.intel.com, pawan.kumar.gupta@linux.intel.com,
        tglx@linutronix.de, peterz@infradead.org, gregkh@linuxfoundation.org,
        seanjc@google.com, dave.hansen@linux.intel.com, nik.borisov@suse.com,
        kpsingh@kernel.org, longman@redhat.com, bp@alien8.de
Subject: Re: [PATCH] KVM: x86: Set BHI_NO in guest when host is not affected
 by BHI
Message-ID: <ZhliaXx0kYzsQ2DX@char.us.oracle.com>
References: <CABgObfai1TCs6pNAP4i0x99qAjXTczJ4uLHiivNV7QGoah1pVg@mail.gmail.com>
 <abbaeb7c-a0d3-4b2d-8632-d32025b165d7@oracle.com>
 <2afb20af-d42e-4535-a660-0194de1d0099@citrix.com>
 <ff3cf105-ef2a-426c-ba9b-00fb5c2559c7@oracle.com>
 <CABgObfZU_uLAPzDV--n67H3Hq6OKxUO=FQa2MH3CjdgTQR8pJg@mail.gmail.com>
 <99ad2011-58b7-42c8-9ee5-af598c76a732@oracle.com>
 <CABgObfa_mkk-c3NZ623WzYDxw59NcYB_tEQ8tFX4CECHW3JxQQ@mail.gmail.com>
 <ZhgIN4LIu2K5vf5y@chao-email>
 <ZhhNBCtY0rgfJdRK@char.us.oracle.com>
 <ZhiphhlEAg4UCUoL@chao-email>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZhiphhlEAg4UCUoL@chao-email>
X-ClientProxiedBy: LO4P265CA0276.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37a::16) To DM4PR10MB6719.namprd10.prod.outlook.com
 (2603:10b6:8:111::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6719:EE_|MW5PR10MB5713:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f9bdf44-dded-48df-3d40-08dc5b0e5f12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	snxQbEC497OfROP0/9v+SdgykG6T2zCTN4hZEAuc43nqEMXKss7DKal+jyd20NRMAPMf3mcKXea52AYLteF72d0d7R5SFBbLSLLf7kVtbvWGAYty1FbagHxYnWgewJrj1BXvlbTxc/xMtlcGMnh2bCT08Ll5Mw9JEu5nBJMwZA/MS/9mwUpKRwi9TMcljUik+Ib6ey9dH2OS9hFIx7Dwn6Tun/f+sThKpW/g1orI/587GNnOnUUbfUdIYvXDNEgrQPkgc/1M4ZZPctGhyl2yyP9Y1IoSY07ODRHrCfpYwB/TA9H2T8r79TYprwgRiRT6OnIllzpDoQFUIKtJSU1OAELDXVSk8w21HKJmCb5Xqj5tVBoxB7RC+vRZxRYg/W6Llyo/LlpQvHoCQUi4ra91/K03T9lpqh4GN8Nx6BNSH3JD3GJPDoe3g1Eb/QV3/IiX/E677Osbo/M1jGLDdOjpnVWdxvw5Qweo64GPS4QON1yG9WkGd4P5262AzRQR++PAO5Pq/tcv3A/nZvIJigJRwy7Rp11qc1u0glG2LSLwTOHVw1oaffN4PvyecHBif1QTtZJz+Mbn9LVqBKPqYkM+1dBaEFMeTbQ98vZj+5fcV/s=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6719.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MTZ3VkxWa0dkTVk3a2wvNDhaNW1ESEtaRkJvV0E2MUFGdVNBWFdJL2lzU0o0?=
 =?utf-8?B?MGxZWHQrcER0a2dpdi94YU5aZ1B0Qzd3aEM3SURmTFlER2NaT3MwTmRZWFpr?=
 =?utf-8?B?OXZseC9oa1dEL1QwM05DY0VwSVlqeUtZWjhKcWdNd1BHZ1B2dW9VK0NJRFRQ?=
 =?utf-8?B?Zml4WWhsS1NxUXYzOElZaVFMTG5PeDBOT0ZkN3hRTDl4bjAxREIzZ0xFdVFN?=
 =?utf-8?B?TXY3VXFDQ0UrcDMxbnltNklXV3AwMDBHRHBlTUtacTVZOGZ5WWN0S2FsbUgv?=
 =?utf-8?B?WlVXQnRsN1lRMm5jVVpCditrUXlkR1dqaW5VaWRObmpyNUx2Nkx6S3RxYWpM?=
 =?utf-8?B?Z0pZaVhPTWVKVk82dHJYamV2dStRblgrb09LMEFPUkJ4UU0zUjZWZkZwdWtE?=
 =?utf-8?B?YXFCemJ4c2ZJdDJUNTEvUFl5OUpVUVZZcmxsY2VOaFVRZWhkSFBJU1Y0T21y?=
 =?utf-8?B?VU00Mkx5dmtPN3BnTEgzTzBKbnJ0MVpUN2g3bkQrTER3dy9sa2FzbWgzY3hD?=
 =?utf-8?B?c1FMVVhrWXpraFhPelVxWHQyb2U0cndJcGx2RzlKNkxZWWF5bzFmRHd0aHBq?=
 =?utf-8?B?VVRFcUE0ZnNHU0hCZGhTZE9ndXlNM2pZVmwyOWxiVXJJd2JwWFFVMjFJWmRZ?=
 =?utf-8?B?TC9WVTVZdG04VE5OeFhrMGNFOElNSjJ0WmxUZ0pHQlVMZm1aaldPemUyeTRl?=
 =?utf-8?B?Ykt2d25lSkMreTJiZG1YTFdDR0pKRkJiL3JLeUxJemljZ0FTRFJtdkhZZEpE?=
 =?utf-8?B?eEVOdEU2azdITGZHWHI0UU05RGsrd2xRcnZ5RzVuejlNbjZ1UmtzY295R0Vw?=
 =?utf-8?B?dEFLVStkR1BjNEJBKzdmdUZXZ1NkamQ2T2Mwek1YZVh5SFY3VkFVVENJQ3BT?=
 =?utf-8?B?ajJiVldBa2hVdVZFUDJuU1BtUWRQYmZadmRndVhDcjdXdFlMa3ZnZ0Z3NGo2?=
 =?utf-8?B?QVNvVlc4alFFc2FNWlRRdWJJc3VuK3IvaDFDYU93aVVucVVqaEFocTJqbWtu?=
 =?utf-8?B?MVVRRi9wZlkrRFVTeE5DajFjeUg2aFdXc2dzTlRpeEdzNzhxOTZ0V2N5OFZS?=
 =?utf-8?B?VTQ1QU55cmZlMzZHSHNUSFkvODg4QkFMdGpFZEo1K01vb3Z6cTlSUzBEYlYv?=
 =?utf-8?B?c3ZRZEs3Z2ZpK2UvOEFPNEovWEllcHlQVmRWRm5neUlIK1pNRU9pUFVGaG1a?=
 =?utf-8?B?bG5PNlI4aGEzcHlrTytXVWNEUUJxWmEySCtwNUV1c0pwV25lampxWkJlVy9r?=
 =?utf-8?B?Rm85RVZRaFllOHB1WEJNOXNFVTBucFYrMU80Vmg2UzcvZGg1WnBsdHZ1QkYr?=
 =?utf-8?B?dWJPYkxBNkxqZ01XUXRreDlid1BzdytkZGVBTk1WZHBGSHQzb3lkOGtNd2J5?=
 =?utf-8?B?ZXJNZDJXZ2xQb3VhL2JyRWRQS3RyaUxVYmlDZ0EyTUlxdFd1R3g2aXpIRGhj?=
 =?utf-8?B?eUwrUENLajV3UlFybjJOZWY5dHpteUJURllWc1J5RUFGRTRXV2M2d3l5eXJT?=
 =?utf-8?B?RkJnZ2tiUFhBaU9VaWZGYzliYmRoek9hUFhxOGRBK1cwREhrUjE3bjA1U3dR?=
 =?utf-8?B?bnlSaEpqbWR5SG0rcWs3TitjN3JhQWNxa3ZmRXYyZm81OFRLKzhBS2xmcTB0?=
 =?utf-8?B?QW9zamVmajAzTkQ5TnRhV09UWHNtMXZMVlZMRmRUM0lxL0FYS3VHdDVORFRk?=
 =?utf-8?B?eXhmYXpILzNVSy93dExhdEhHbDAxWE1NempGOFRPbEc1c3JwbnFieGxFZWRi?=
 =?utf-8?B?N0pxYTVhNkw0UFYvWTBFbjRzNkhiS1JRRVB4MGhQTEczRHlMUzgrWGNyOE0x?=
 =?utf-8?B?NDFHZlIxTkxZcnVjY0ZxWEcwL0JFTnZNWG5QNHpka3J5a0V1Y1hEYjl0anht?=
 =?utf-8?B?Y1ljNkEwZDBpa2lNT3Y5RW9CQmdWeXN5ZmZQVzhFSnFFZnAwT1FMTVRrVzkx?=
 =?utf-8?B?RzFXQVIrUTBQd1RZczh3M3pFN3ZlT0NQNk42cFY2S1hISGpsNlFUZUNEUTE1?=
 =?utf-8?B?RWZzL3JLbUZ2Y2IxQ1Q2UlNLT2lLaWdWVmk3M2R3ZUYyZHR2QVZ2aWhmalE2?=
 =?utf-8?B?QjY0bzBYbGNiWlBDb2kvU0l5NndZVWZrb2FsWTR6TTI4ck5RUHl0TzdPN1NL?=
 =?utf-8?B?cHFBanpMTnFIMjY4SThJdkkzTXVnclpxb3ZFME9iM09JMmNyM3RpUFEwRGI3?=
 =?utf-8?B?ZXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	NkK9yYPUXjIDHKw+9Dp3ZUO9vB41+KhcN7LzYyT75+ecLzEW+xsl/ipN8v7dDPW0EaZ32h3ASDuw020XD4KbczZFIfd9mfoWinoYJe5IOvheizPWKmSRd9LJ9WjDsfod+29eF8se9PJLJb0Ang2WmqGyVIvUxmBqm+kIBIQJdHpsiGY5RoaXNgkolYkN55ZMWd4ydkXnje4joRxXKVDyZeC5tndP+Z2a0V4vMpc5dnRsCjRQIu5gkBZ92uGDVY6/ZjX8XbmzuTZ1LCzMyIz/8zlGg6E5awsEJ7Az7cEmerVSr1aqkRjSv2VqaHal2Aol4GUy6jlU9a8ojHAtmb8OI5otEfeh0Y/eGYrTSoXEZnbC18b8AAmY/VOTIoVFVGskJWN5ZsQ/8NcPvVjlhG9gBIlzSlvq5uNoNvg2yKxpQkrijbwaOvcbG/a7q2hQ521688r1wXq2dc+CYqewhjPNjmAKmaa24/tEmU2c+GBvnkoyE2UVToseF/RzGC3mdcPL9BvTDBrKgVvYqs7yO42KO3HYvu/ikRHMrkC2honPJaQNrMfl7ptJ2Vh1eRaaamcc1OszAyRvXzBs1/obrvuBEYGWloVug4ancgcZ/BrdZwU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f9bdf44-dded-48df-3d40-08dc5b0e5f12
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6719.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2024 16:34:06.5234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jIUauCWTgZOjXFkqDPNtMjiI+54Ql/2KADRsy86SrVsQQqdMl7J6mdJ+e1SQuO+h5PY0ifA2GUiO6iQEt3ebzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5713
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-12_12,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404120121
X-Proofpoint-GUID: 31fMFXDFskDjnZMcrDnM7qo2-pnsUnr4
X-Proofpoint-ORIG-GUID: 31fMFXDFskDjnZMcrDnM7qo2-pnsUnr4

On Fri, Apr 12, 2024 at 11:24:54AM +0800, Chao Gao wrote:
> On Thu, Apr 11, 2024 at 04:50:12PM -0400, Konrad Rzeszutek Wilk wrote:
> >On Thu, Apr 11, 2024 at 11:56:39PM +0800, Chao Gao wrote:
> >> On Thu, Apr 11, 2024 at 05:20:30PM +0200, Paolo Bonzini wrote:
> >> >On Thu, Apr 11, 2024 at 5:13 PM Alexandre Chartre
> >> ><alexandre.chartre@oracle.com> wrote:
> >> >> I think that Andrew's concern is that if there is no eIBRS on the host then
> >> >> we do not set X86_BUG_BHI on the host because we know the kernel which is
> >> >> running and this kernel has some mitigations (other than the explicit BHI
> >> >> mitigations) and these mitigations are enough to prevent BHI. But still
> >> >> the cpu is affected by BHI.
> >> >
> >> >Hmm, then I'm confused. It's what I wrote before: "The (Linux or
> >> >otherwise) guest will make its own determinations as to whether BHI
> >> >mitigations are necessary. If the guest uses eIBRS, it will run with
> >> >mitigations" but you said machines without eIBRS are fine.
> >> >
> >> >If instead they are only fine _with Linux_, then yeah we cannot set
> >> >BHI_NO in general. What we can do is define a new bit that is in the
> >> >KVM leaves. The new bit is effectively !eIBRS, except that it is
> >> >defined in such a way that, in a mixed migration pool, both eIBRS and
> >> >the new bit will be 0.
> >> 
> >> This looks a good solution.
> >> 
> >> We can also introduce a new bit indicating the effectiveness of the short
> >> BHB-clearing sequence. KVM advertises this bit for all pre-SPR/ADL parts.
> >> Only if the bit is 1, guests will use the short BHB-clearing sequence.
> >> Otherwise guests should use the long sequence. In a mixed migration pool,
> >> the VMM shouldn't expose the bit to guests.
> >
> >Is there a link to this 'short BHB-clearing sequence'?
> 
> https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/branch-history-injection.html#inpage-nav-4-4
> 
> >
> >But on your email, should a Skylake guests enable IBRS (or retpoline)
> >and have the short BHB clearing sequence?
> >
> >And IceLake/Cascade lake should use eIBRS (or retpoline) and short BHB
> >clearing sequence?
> >
> >If we already know all of this why does the hypervisor need to advertise
> >this to the guest? They can lookup the CPU data to make this determination, no?
> >
> >I don't actually understand how one could do a mixed migration pool with
> >the various mitigations one has to engage (or not) based on the host one
> >is running under.
> 
> In my understanding, it is done at the cost of performance. The idea is to
> report the "worst" case in a mixed migration pool to guests, i.e.,
> 
>   Hey, you are running on a host where eIBRS is available (and/or the short
>   BHB-clearing sequnece is ineffective). Now, select your mitigation for BHI.

And if the pool could be Skylake,IceLake,CascadeLake,Sapphire Rappids then lowest common one is IBRS.
And you would expose long-clearing BHI sequence enabled for all of them too, me thinks?

I would think that the use case for this mixed migration pool is not
workable anymore unless you expose the Family,Model,Stepping so that the
VM can engage the right mitigation. And then when it is Live Migrated
you re-engage the correct one (So from SkyLake to CascadeLake you kick
turn on eIBRS and BHI. When you move from CascadeLake to Skylake you
turn off BHI and enable retpoline).  But nobody has done that work and
nobody will, so why are we debating this?

> 
> Then no matter which system in the pool the guest is migrated to, the guest is
> not vulnerable if it deployed a mitigation for the "worst" case (in general,
> this means a mitigation with larger overhead).
> 
> The good thing is migration in a mixed pool won't compromise the security level
> of guests and guests in a homogeneous pool won't experience any performance loss.

I understand what you are saying, but I can't actually see someone
wanting to do this as either you get horrible performance (engage all
the mitigation making the VM be 50% slower), or some at runtime (but
nobody has done the work and nobody will as Thomas will not want runtime
knobs for mitigation).

So how about we just try to solve the problem for the 99% of homogenous pools?

And not make Skylake guests slower than they already are?
> 
> >> 
> >> >
> >> >Paolo
> >> >
> >> >

