Return-Path: <kvm+bounces-69681-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aOX/DD1nfGk/MQIAu9opvQ
	(envelope-from <kvm+bounces-69681-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 09:09:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A9D7B82DB
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 09:09:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D625C3029241
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 08:08:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4237934F48D;
	Fri, 30 Jan 2026 08:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aCecFGi9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6ACE329C49;
	Fri, 30 Jan 2026 08:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769760532; cv=fail; b=tLUaq8urd8PZ+8Y+0IzlrWYWJgZwEWN4xS2/EYoZCyine8ApTfbHAEXJsWWuaJ4f8lt09SXQTdXmKz0ycrz4xjIOs2V7XOdUHgNWJpbf+NPSWnOWw9jVhtF3qxilOrHoXELEv7mY4IPpTwAPJ0mSkTkLk0SMu+cq8Hh7kcFE6KQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769760532; c=relaxed/simple;
	bh=/xMuHdoH2GDUlVOI73V5OIy1J4DUuTDCh78UTybpXWI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uZ/9SIWW5o3kwqECfio9H4AD5uE7mvSmL0wCAPyFAUalaF6EdUgcHLFxCRzn2sTjPliMCX/5bX89yIZbRWJ7JoMHsHwbiWbBfTVlildpW31335t/BqTQPX6M0xaChbzUwS0H+UjIJG2xvO0Yz6ITaqpGByx2/Fo4iXAkAHW10js=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aCecFGi9; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769760531; x=1801296531;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/xMuHdoH2GDUlVOI73V5OIy1J4DUuTDCh78UTybpXWI=;
  b=aCecFGi94n1BCaAWxLYYdVOITZ5W4vTyfV8DL2G669Uo1XxLDeFPVzcw
   YkiGCVQ9QRESFD6d7aF52rsAB36YWmZ2HedkcS/Ccl6HDgHVZX/Hb4gdo
   nNKbWeJjFMz7wupZo1yY/ZV41LieYtxmmDymoS5hRfNfjBYChYd6fhzPw
   laoO6OrKW7nn23L8ynyQsHgJqoleeqhm0SGyx7LtPPPwrbaRxy+pvABD2
   Scezo0pv0EOXNuZkdoYG8XkNxH8ece2SZ/i9ECg6/y4EGr3SeMZdfpilx
   vFOAXgUKTEFhmMqyXkd0f8Baj7v/+/ur3DlroCkkyn5cizxqIp5bzALrO
   Q==;
X-CSE-ConnectionGUID: wlsYNRK7QF2bE08pNZZSlw==
X-CSE-MsgGUID: 1IEifgi5RdWvmglv9r5OJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="70915920"
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="70915920"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 00:08:50 -0800
X-CSE-ConnectionGUID: D8dR28yDQfyd0H1rmRKxLw==
X-CSE-MsgGUID: FfHd72tFTiajvX/rj4J+Wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="208597718"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 00:08:49 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 30 Jan 2026 00:08:48 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 30 Jan 2026 00:08:48 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.16) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 30 Jan 2026 00:08:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=orQmaIu28ohN2nv6DsRcsTw3duhilE5SJP/P4/dM9taZBMQanEdNa3QJHMK6PIGDVKHXkXWi3Y4K8ZNEj7NvC5zKirw8q/bpjyZBM6MqjaDzUbF99V6hSdO6iEf7cQ4Tfdsh3q1JqgqyTjKcxzFxOwWnw3fGbRh41R5bSNLxHAD7HraCtoelHwuHT90Acob/AQAPMeYU9V5ZaJuUWTecY5EZ7v1NiRvCRhXP4tz/LMdcKg937PZe643xqjrByfWc8um7E2RsTapw63VvdYombgJ88tN1hOZ+n8sG0uX4Ti4LKgQEwhoBzm0M3MN957XzuPo52mc0ucnX9rO6kWmRWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hRzZshmc1rH6hh8V3AWYQEB9hG33wfar9GKER4/DWeU=;
 b=JpymYTgi4Fc9kT7bL29Q/UWmiAb/Y7NTZSHg9OCdvu0iANwARoU2hDQ7KVg5IW5g69wfXmSvrkEz5yHCQKQ1iEW9uLEIeprdvrnee9p+SGNGiQ3YdfUXW9Muj5VTXEcvmRPMah2EpYSYYhPo9De5W8W562NPBtDOvAEiItMHDnfxUjy1kkBHitUmuWHLOw8R2oFyE/WoqZ5uT5GBb7QWSRWewnXQsr/ph0dMdrKjhklOi705UgyDzQGmjh/5e5XRdDiywMxVVhKj9/Jyw+rjCYBeGXYzvAxj5zxvove8+pTFxOjiVAnQ3KPeaEzmwa+KTm9rpe8gk76jM3zD1YYDpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SN7PR11MB7668.namprd11.prod.outlook.com (2603:10b6:806:341::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.10; Fri, 30 Jan
 2026 08:08:39 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9564.006; Fri, 30 Jan 2026
 08:08:39 +0000
Date: Fri, 30 Jan 2026 16:08:25 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <reinette.chatre@intel.com>,
	<ira.weiny@intel.com>, <kai.huang@intel.com>, <dan.j.williams@intel.com>,
	<yilun.xu@linux.intel.com>, <sagis@google.com>, <vannapurve@google.com>,
	<paulmck@kernel.org>, <nik.borisov@suse.com>, <zhenzhong.duan@intel.com>,
	<seanjc@google.com>, <rick.p.edgecombe@intel.com>, <kas@kernel.org>,
	<dave.hansen@linux.intel.com>, <vishal.l.verma@intel.com>, Farrah Chen
	<farrah.chen@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin"
	<hpa@zytor.com>
Subject: Re: [PATCH v3 07/26] x86/virt/seamldr: Introduce a wrapper for
 P-SEAMLDR SEAMCALLs
Message-ID: <aXxm+ezJvwUQ4sfD@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-8-chao.gao@intel.com>
 <04f9a748-fe61-439c-af80-59c498970580@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <04f9a748-fe61-439c-af80-59c498970580@intel.com>
X-ClientProxiedBy: TPYP295CA0056.TWNP295.PROD.OUTLOOK.COM (2603:1096:7d0:8::7)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SN7PR11MB7668:EE_
X-MS-Office365-Filtering-Correlation-Id: 19726718-58f2-4433-df43-08de5fd6c650
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?HnfuiuBUEfmVlqJTdlzy9fSbt7oMwfsk/b7ka+RY7kGseSIf+hk1MMgq2Id7?=
 =?us-ascii?Q?KAYvL+0cmFxYs4AtWY37KxGKGOEa+XcBhDYusF3Fp0nFV1gNDmetJqXoaOMK?=
 =?us-ascii?Q?YIFJZ6+IO5UBjpUkbRClNI93UdmGaQOcQm0DQH8hW/oYsH0VmDYiTZ/HjV2B?=
 =?us-ascii?Q?6FPi5ijtwRo4B9q1kOWyyLuIde7iILhox/S6H5ylODwO9kvhHIZ4A3d+yW2l?=
 =?us-ascii?Q?pkJQ9nEeSVIRBxB73MHlfori1wu49BhLfWFOeUkX7UaX4Kh4FEnKSTeNO5Ar?=
 =?us-ascii?Q?Feqaht2UA6bvqOHQ+7Cxocbynbww219+oqbQpDp+GHLW6CoI59YFX6Oj7UYq?=
 =?us-ascii?Q?9y4P0QiQYjJBZ+lyV3d9vi751VDXX8KhzAAw20TwUfS2yim8tutHvaH1igR2?=
 =?us-ascii?Q?5nV55WNg08jw0R+UEqyTLSFhGnsX0r1JRcIIXjgZaKIRsmGKddB39Y641Qq8?=
 =?us-ascii?Q?P8ugg4nlcz/MPxjLa9We9Gj1FdhAyi3JeFP7dsbdMbGnEXWC2eXOx/JtrpHp?=
 =?us-ascii?Q?OyJRYtWnZnyZ6P5umxyT98bWX7SVNCXcfjfeTXIpxVx1o5Tg7KvUzMISGWlf?=
 =?us-ascii?Q?LX1lSwjEC2kIrAx2qoCnl7x2Pg8AnIRfroiBnPGETPpeFiCoRO2TmqnAivXh?=
 =?us-ascii?Q?plFJhdRawURYGLzQdg7vzZ0t2rj4kQ1zgU75XXDP484lAGzcfO6HL/vS3C76?=
 =?us-ascii?Q?jw33RSBUPaSMwHnckuyVSbDYZTPYwpz1OGNGt6tTucDJGkuS1cAYWq76DRG5?=
 =?us-ascii?Q?0uonaChxLbovmFY9yxiJ+NGI75VCUqdS4sPGerRdrOIm+n3V9atkrS78HZGi?=
 =?us-ascii?Q?P7G+G++r5VN+dJ2XUn7txR0i/1KzTm672c19NRS/VF0pyDK7IP/4EdzbXIhP?=
 =?us-ascii?Q?gbpcxL+IYxuCsl1BrjXlYs5/+toYZroMsbDeMT9hbQBDcWA752fWVDyPOw5w?=
 =?us-ascii?Q?tBFtGjvlYshJygPlac54Cf3Lnuwu/Ede2Ly9ko1+DyaGVzrhZZrm+gulC4ca?=
 =?us-ascii?Q?d3eWLFr0FQTxKbm4LBBPrSdxh7UnCOuVoNxbmBR4VJTkgh4i9E+Wrf1hZNU7?=
 =?us-ascii?Q?bTM3S5BNNOMD6VSB0/o6weH0uvwunFI88B98Y7kPjJMvCpzk8lepS4r5XC/9?=
 =?us-ascii?Q?ldEODlwRPWYZgqqqtxdoFRYRnZb7LwLR/11itvfaPYUtaMuTJACh5ndEgS+q?=
 =?us-ascii?Q?iG3E91c6pICF1p7SD1MyHpH8EPBR3Uc0a50s+f4pRXPL9O2VxWTc3gTatXTz?=
 =?us-ascii?Q?/QS/6UAI45SG3ZLuqqFPP7IRXC4BvOnuJDh4ZLSI2WVKNSUpY/ZkHBU/Imw/?=
 =?us-ascii?Q?/mNhutIPVi5Z+lM076cF7TRXgg4NsSf6DQyHO8lznxYYyt46uLJTxGo6COGq?=
 =?us-ascii?Q?iW/BQFUYK+AbYyhJC1xiYC4OTIJvPOP1+9FFxi6a2a9yRI/aqQTo8+QGShB2?=
 =?us-ascii?Q?G3hI9sANY+bRK3TFJIEAOruNNDN9UwPtddG81xc/M+RKHE1+m41qWChWA2vr?=
 =?us-ascii?Q?4zlf2MZt3IHAjMjlX0SQ+TmEcV1n7U471t79Sq5Jni4OqaZNbIuxs8FUmcgO?=
 =?us-ascii?Q?moxnE6wJcQ/ayU7VQf8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?88rfGi/f79Q+A43jvMvGaKas5DxcWhFMgU44N+vbDZwO9LGha4aLnlnYaqIz?=
 =?us-ascii?Q?b+I1QXoIb9l34/E8TBik7bi4s4CxoFWcQJerL81oP+GgGE1BtX54w7ZNlHa9?=
 =?us-ascii?Q?Q1LFw4Mi3+RmCeT4EkRDdXQJoWYRDpqyg9yK8se+ep4cegPdyzSe/hKafF2W?=
 =?us-ascii?Q?i/MoJy9Tuzs4ohSrml2qAq2tptTfCOT+WC+chgTYOpOHLb6BoyNcH4Tz7mex?=
 =?us-ascii?Q?xDFZzmO66Wej/uX1oMCEus2ZSM9nz+TuVTu0OqPIzLf0K23YGDlle9VayuEa?=
 =?us-ascii?Q?d47uaxXQoODCvqlFQgA64gUEv3z8r8TauMRSD+8VGmrWrTdxZajq+gt1YF9Y?=
 =?us-ascii?Q?WlD+2pY6uN69sJgaSo2yfCeki6hcZL23aWNIJ6ipjLlZJQKak6zZvuE4n/HT?=
 =?us-ascii?Q?06GL0G+acuLUIfxWvHLE5wI7RTg7gfQaDsj2NsTD4u18O5LWwNL0DtB2H+Li?=
 =?us-ascii?Q?+plQ64WtYIH0BsJckUQQbM2T7mKJqts5eoxWQIAO7H32GgKMeLmUp96+7p6U?=
 =?us-ascii?Q?d8SsTrHHad+2QTf4k+vkIEYWeNjoSYVcz/WFASZn+jJsOdtwZ4QR+pDGeJhc?=
 =?us-ascii?Q?YtJgArZpv3hPpsago60jN+9DPHE+R/iVNK/+yZVIiXpc9CyLtE9TU1SiPgux?=
 =?us-ascii?Q?YXsLPdYn8L5GkLESQUsKSF/T7hjzuvFuUjVuU753Qym5yJqiYDzlrBBTkwea?=
 =?us-ascii?Q?yPwE9sfP1e4Cosdw1RDWio7c+fwGU/tQkBm3EuWjqRegN07H2Ylv7mIoYF4m?=
 =?us-ascii?Q?vM9bLFnMVk6F4hOU4hCz6SeVe6eofzQnDq7DLmFwyDQVh1Ba5mK8nhX1jHsB?=
 =?us-ascii?Q?28TQ34JF6hQ0BUrZjxoFl6IWREsxoZuPuHt44cX5rTX8cV4RGZt2QDV8frBl?=
 =?us-ascii?Q?bYsXZHZxUw1WDujsQaUGpV/lajihpX0nuD1vJJAEEJ1vQ1QsnBjrS1BYjjKW?=
 =?us-ascii?Q?lqNp8V1mlmeW6R3+kcLtmHnj3oOzqgNaFmR+N/Aj+NXEKX9G5UZ1Mz6fn0Lu?=
 =?us-ascii?Q?IQ6MElQcbs89FRoimv8XL8gnIxSaSFQVToZN6rP6C0hPUbezENC1wy4E2SBx?=
 =?us-ascii?Q?za2uEARJ+ntU2GKo0UnDKS7IPzjUmbyGjvWf6kynbqCVGBIGZBUIcVkYFxKI?=
 =?us-ascii?Q?evPphvdDDKqeWi5Dif5PRhFSPpiSXLmGpuI1r4ygRZEs1TstQdcr0f6tUE2p?=
 =?us-ascii?Q?SL3Q51Cb4lSPz3n1U4iZZITRrMfBu9k1ZKn5fdgS7NgYStopPS6YtkJUuVEb?=
 =?us-ascii?Q?eQGOCliJ/51lIu5OkuVn5g+puwZFIDuKYmRHEkrQv2Nq5ecJbXHePDKLsCY7?=
 =?us-ascii?Q?SZTAUjTpfazFkODpnWErCUg3PINGZzEeRSk3JOMD3gEvG7T8G3INIbsHcHU+?=
 =?us-ascii?Q?3bKJQd58yxOcvZl7G58XaynDDiOn8RYI9/9csSNme9veX9zeJH6lkc5pww/J?=
 =?us-ascii?Q?nlzotPFTXjnC9rb38Y1NdwY9jt5LaABUpFzkfm4q/6m+kUP+gQVt2u4dWwx+?=
 =?us-ascii?Q?bjQNb5UgxGzLsDw9993WRYK8fUl9pbybxcD/gl/Gz5rNiRvb/rR/1jiQJ5P+?=
 =?us-ascii?Q?/L3hVLdCW8WbsLUlNm5H3Oxd+ak1hw/Wm//vm+fhAEafdHBqUYDKO2sEp5u4?=
 =?us-ascii?Q?eP88vbRlA2f6/yQln3xaQcZjWbvi4N2Otqebubtl6FSFxlYiXPn6RXO5VlNh?=
 =?us-ascii?Q?G+X0JRuRKZm54PWZ/EJofkZY06XQHG4fAK8oUgqCnHsbZw53Nc17rZkEdxLK?=
 =?us-ascii?Q?Mx+zVIP5CA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 19726718-58f2-4433-df43-08de5fd6c650
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 08:08:39.1507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YzEqIORa/c8hyl0RUBN4Da6E/ddHjx1vfmrGDe9waXksiFrWubIajYyTf5gyww3Mq+fq2VKPuZzv9Nt1sKU14g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7668
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69681-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 7A9D7B82DB
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 03:04:55PM -0800, Dave Hansen wrote:
>On 1/23/26 06:55, Chao Gao wrote:
>> SEAMRET from the P-SEAMLDR clears the current VMCS structure pointed 
>> to by the current-VMCS pointer. A VMM that invokes the P-SEAMLDR
>> using SEAMCALL must reload the current-VMCS, if required, using the
>> VMPTRLD instruction.
>
>That seems pretty mean.
>
>This is going to need a lot more justification for why this is an
>absolutely necessary requirement.

AFAIK, this is a CPU implementation issue. The actual requirement is to
evict (flush and invalidate) all VMCSs __cached in SEAM mode__, but big
cores implement this by evicting the __entire__ VMCS cache. So, the
current VMCS is invalidated and cleared.

>
>KVM folks, are you OK with this?

