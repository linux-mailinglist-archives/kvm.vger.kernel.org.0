Return-Path: <kvm+bounces-41030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 41386A60CCE
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 10:10:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0811419C21F6
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 09:10:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98E4E1E04AC;
	Fri, 14 Mar 2025 09:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XAMab43H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACC31DE4D3;
	Fri, 14 Mar 2025 09:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741943437; cv=fail; b=hjPMLEeBU/8fjkCl9SrmSEfMDbvAj2ecZxLxELCWe8YAPd9+8b7l2QOUTOrUL1PhFGenCL2jEUP0NAcZJumyHsuoBUdTYmMwwnf80D4VIn33q2+OKDOnDLldMfydx/VDmdQ8xE7ZMjbkFLejUE2EN7NBXd/Rjmkcg4hRkKL88Sg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741943437; c=relaxed/simple;
	bh=S3x+anrc4QQjiFJLejRxkGHCRIynY/mSYCyJJaJLnRM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SoCQIQB8YVnVTYrVA951LT2dnq/bLd5Tc6ty0IxLf+zVFOGeegp0pGbdM/0zTT4TODejdfCiG05WFldN/Bz3zgmSNB+hRRnyb7oohY9HQkVfQdPhrZ3jzkryAacG+G/jOmgPAFPwUt78j3PDgL32NXMLCgPbPYzH6uUeZMk10X0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XAMab43H; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741943436; x=1773479436;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=S3x+anrc4QQjiFJLejRxkGHCRIynY/mSYCyJJaJLnRM=;
  b=XAMab43HDHrFWLyn2v/TXXls+kAwBZvV6WqBacFA4ILUINyJAQ7dylK1
   //BJPOB2mC/8as95XSx1LOaOXT2UM7u8Ovp4icjdwOAzf7O1MDRiIl++h
   jD9A//ZCnfH1mOK7x6ZILc/pnHEx1qKpigf3D7w8oolHCcnhmfcYbrdOQ
   sVxTw1ZhhNKOCgPwQX7CAi0BF2kgoOsuBH6x0kprInW3LPmQcv/i0t0W2
   JivAKDeq1FuFgI4FX+S3rK5i//wcpedRCNnnOl1y/Z8j2G3/VHdmoofrh
   VZlASLP+s409qHDWaMiDizjnpbA0trWyl7PH+d8mKhhhptEReV+3xioTi
   Q==;
X-CSE-ConnectionGUID: DL+ixn6OSzWJLAWoOwkeww==
X-CSE-MsgGUID: r0dT94QASYeb5hZHZ4+/2Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11372"; a="42257755"
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="42257755"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2025 02:10:35 -0700
X-CSE-ConnectionGUID: SllocYBbTE+hk9rtR0ztPQ==
X-CSE-MsgGUID: 0JZ7+x3WSf2nOjG92jhh8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="120934654"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Mar 2025 02:10:35 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 14 Mar 2025 02:10:34 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 14 Mar 2025 02:10:34 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 14 Mar 2025 02:10:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IdS4QW/cXbkWS1ae7OKFp0c29Di8vh2D9YmMqg8rl8IiyrTzLkEL//IQ6TfXVmuI0qTEVbzyitzhQTnXQemK/I24qkxS9hbWqnlIS56KEkdu0gO4daMxiT3qnoLfSyjb3UA9K5wliNcuzXtAjqqICWo2alZ1kyAm6PFjvZQHelMuS2pzPQUSyHAPMaMaNcQMwl9Noa+1DMfHRkX8dl6S0ReoIZamv22w9LE9S5qNqwsEvUicFZ0/goNTtDJHOvadoyydYzDXNla7RTh5YoMwqgBJXv/kUKfuj11Ta9IuSA3KZh4Vk8W1PqRGZ3zhHaV1pZwVb0GxxYxjQhNOpHHOZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kWBvwZ4kM89sArpwCjiapEdtkk6VjglESr9VIDlRNHs=;
 b=Jim8sXUJGuEf5+CZZDgXwGVbLPaV5OmFTWUejSEBU4+EP3v8ZAujXuzUXHzMSW/fND1Q5mMgZaKxHjhbMJvSmRikiKn7UCxZc4tF5XeEEanP5/hRMD8NCqf/wMBSMEF4cwZufwHQVW2DluuolcfpclvkkOKr1rk+QprYdNbT1yFed3sXStPWliMtjbSDrlP1m7Hiz49tWRcxkZKlhRf/bAJUFm+lkNHazJniF067Uzp2UH26jdztqQUl8F3fyOD7MP6++wx9ftIPJMmZ8XurGupTCUdOb2IPtjTFFYUIjvC+oic2s+Is41AmNEK0m0qEqkC3VbI0N4S8TrBbTknPgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ1PR11MB6129.namprd11.prod.outlook.com (2603:10b6:a03:488::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Fri, 14 Mar
 2025 09:10:31 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8511.026; Fri, 14 Mar 2025
 09:10:31 +0000
Date: Fri, 14 Mar 2025 17:09:00 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: David Hildenbrand <david@redhat.com>
CC: "Shah, Amit" <Amit.Shah@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Roth, Michael" <Michael.Roth@amd.com>,
	"liam.merwick@oracle.com" <liam.merwick@oracle.com>, "seanjc@google.com"
	<seanjc@google.com>, "jroedel@suse.de" <jroedel@suse.de>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "Sampat, Pratik Rajesh"
	<PratikRajesh.Sampat@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Kalra, Ashish" <Ashish.Kalra@amd.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "vannapurve@google.com"
	<vannapurve@google.com>
Subject: Re: [PATCH RFC v1 0/5] KVM: gmem: 2MB THP support and preparedness
 tracking changes
Message-ID: <Z9PyLE/LCrSr2jCM@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241212063635.712877-1-michael.roth@amd.com>
 <11280705-bcb1-4a5e-a689-b8a5f8a0a9a6@redhat.com>
 <3bd7936624b11f755608b1c51cc1376ebf2c3a4f.camel@amd.com>
 <6e55db63-debf-41e6-941e-04690024d591@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6e55db63-debf-41e6-941e-04690024d591@redhat.com>
X-ClientProxiedBy: KL1PR01CA0004.apcprd01.prod.exchangelabs.com
 (2603:1096:820::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ1PR11MB6129:EE_
X-MS-Office365-Filtering-Correlation-Id: a22ea806-084f-4207-8405-08dd62d811cf
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?jyFjQLXo++tmLLGxKcJKCOWyo99y6z88gAwk8TDvXVvucT5J0kvq0QVTx+7u?=
 =?us-ascii?Q?QiwwGLWW5/ICGlQsKQDL4Se1ik6mVTzEqw3/SryEMnJzouRKie27O1s/7Iw/?=
 =?us-ascii?Q?J+lCONNio4kZb+8HegoEV6V0iEHlr9JVigtPN3HlDkQFhEW5ZZciq9YzKi3e?=
 =?us-ascii?Q?WXirngkyOwMBoD8hzozy0VNNytL6dNNP1GIzi0GkoD3FMjgtsVNxiOf+fY7w?=
 =?us-ascii?Q?7YF4FR4ObhYOFwTRiqjAU1pW4y7sr+ilyK76QdcX83aY/XHKZQdrAYOTnKRI?=
 =?us-ascii?Q?RIUs1kknsL//G/+tZsGT+IdFv9FuZDcz66c+4L6h+Zds9RL00W1Tp1AjSXgu?=
 =?us-ascii?Q?e8QYfJmsanbt7eNSQafBFYZKNBdzY7DrBLV5SSx57/Do3uuUC1g5onjKFj1b?=
 =?us-ascii?Q?5UtnQMpzAsqm7xoCMHTIbic9BmBkWDlh1AakJOW1FyLHZZhFq4Q59sj5XZgv?=
 =?us-ascii?Q?tWBXL+i7IDEFg/PKt1TLUgYWJ1D8AuWI6vcPd9jnRyFhBWTJoiAIOxbk9Za8?=
 =?us-ascii?Q?Q0ph32lqlppr9fDhXGd45fSUkKmQAcycsbpRLRAY+2w2MtOUPPuXZHmtOkk+?=
 =?us-ascii?Q?0iu80vwVXK3NazhbIXi9pD107/3gvq/L+NF73bM10xtujkeK4QZ6coHcsrkX?=
 =?us-ascii?Q?6BAgGf4o93pwgvs5FzGmnjUNQroT2E4h3XpymucD3XsBESGqZlZoQEBh+qvK?=
 =?us-ascii?Q?OGZDzIzCFHG/ygFAxyIHNzbd6FYUpGdFbQOmtxaoQNC51PlwNpGJrBnzwE97?=
 =?us-ascii?Q?7+QGSqShbA1D9UCUw4NWAgKFmYpD1XCR9M8EX24nHs1zm/vjERxBxIKuBYOr?=
 =?us-ascii?Q?YMP/yUE1huCl9S0yIspA1oaldSdJBXjve0/YsL4dSnJsImiVzKTZp6+vm1ND?=
 =?us-ascii?Q?c0nPxm720OpaPNx6TH07VU7YzaXZi7edfUheBMphkYPCFI9DJnmP3l6qx1wK?=
 =?us-ascii?Q?a8W1ButKkm0b0pGMufIeRcsLoF5Lg3gC1tw8Hu8rxvVDTlxq7IsNaTquSXk3?=
 =?us-ascii?Q?qbV1JYp9tx0KfxoPYIwi233M8QrSFJH7DahrwR3rAjvhaOtxrcDJ+ZgwSlX+?=
 =?us-ascii?Q?lVKtSQ6Q8Klj9+rMof72zeBebn04/wjzJ128Z7WS5pNiMHkscolsUJU4Je4Z?=
 =?us-ascii?Q?enb5yHvqUdMJ8cEYeQfN0x2TfzIpzlVuyUn3egzd96GmhNqY2JHn1hCItUKu?=
 =?us-ascii?Q?4OU3V8fSp3aobJH+hiFpxmln5/E77xS+KnyF31xZhrSST0C6DgQeiLQ6WMQv?=
 =?us-ascii?Q?ERIPGSVtM8MYiFV4QhbsMf5V5pBPT+VbQNlTffrRvNZTIigYV5dzZ8zpqgjL?=
 =?us-ascii?Q?ab3Lm+ptU2EOmSOQXRIVf96Nkk3GoYaV6TKmS0WZ+rvEKqf9I4v72rWhYelq?=
 =?us-ascii?Q?udw6YcPCejduIyDZtcrnNQpaCc8W?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9/laIK3HKfbvdQf4OI5y9H/AdMEOd+ew6dzBt59ze5GtT2i3eoa15YdawZRL?=
 =?us-ascii?Q?ia47nkwtEDh7qoXjomJMqjw4aW2W5fgd6aoVKpnkPuGSTEm6bVnOciWeCOew?=
 =?us-ascii?Q?dte3EGmCgrn6BlsEGcTxOFPiWOK/ChWCuvSHvykUI8ix6gmrOKrct6C7xqda?=
 =?us-ascii?Q?SfwD1+eegIHTtKL3TeT2Xf8mq+uKST3qmu9LUwq8emUEHE8q2pHZYpCCSTya?=
 =?us-ascii?Q?3AKqn1ddJbOsf6IBXNFZ0XYv4fq+A8p586XNTtUDUGhpN3t5DwkvpzCOiyO6?=
 =?us-ascii?Q?r6KvqaY2VrPsMEyi3IzvG4sCcjuTJxM7MH2KDJPJXu9P0VkFAjpcoCWFz/s2?=
 =?us-ascii?Q?WeKD4C3VTCShzoUiRBg0JwJwiWy5eXZOh/0137PKxb79mxWGkyd5BrGFrul0?=
 =?us-ascii?Q?8sw7dWS6TrrE6/uk9snVI9Z0UNhTx04J0bVDAdLKx5kGQVQF/3E/FRnLMey1?=
 =?us-ascii?Q?nsU3Tug4q56/0sObmlI5lOX1p477ugNeTmrB4/wApXBOUq+mCNMBnvhFY1p0?=
 =?us-ascii?Q?UN43dTUa4gEhpncczXDfR6nOOGDwxLOUu24Q7cNDwUolcJ+uUmsVkYfbdfRb?=
 =?us-ascii?Q?UfTA+fqnweMZ326cBjxsnvSCeRePmqJntky+sgFwTpyM/gvskTCazkf5YGOo?=
 =?us-ascii?Q?rmdzgi6HSHC0NI7KuNfPhGFdoqrlDnewqVqFnuUqXrPhCkuwBdthI59vO66h?=
 =?us-ascii?Q?h4PFCxk2z7tQXZ0LdZ1iQYd7+CjFOWJ4NMch38CblQ2Cn9/YZ1+UTDhxWeZd?=
 =?us-ascii?Q?lqi+vQCKNjx8kIDEI0S35dxVLU1FBOG2YWWQNsWL94Wtzx74iYXG65TfdRUY?=
 =?us-ascii?Q?qGHnavbdWTEKDt1lOHJhh8egAUqzg6NxjCDvFVa4wPovRLkFSeLTkm9254dT?=
 =?us-ascii?Q?MeEQBCHz2+5ptcYh1in1FXemNQAXp1SVFlD7/eizqZhf+1fLH2i9Du9GsvEB?=
 =?us-ascii?Q?qwcyN/8OpyYt8pdv1GRI4lF5RwdailI0+ZZfWd/moA6TZCDD/SuBI6JcUtvf?=
 =?us-ascii?Q?Qvfd8Su1N7KKP89+ISR409kepRLTbjWgHn2L5EEqoG3NTKXUpl8YQY//ngSZ?=
 =?us-ascii?Q?aiW9k0miLnDV5qNk6nMlj7mADPs6+tESOgwbG5BEuziz+3D1LePhMKcLpVFt?=
 =?us-ascii?Q?231+ut31988HD8rDVYC5gaMnUqtYZo7+UJvIE6GSXrmfb1ankOSeRZ7DebLK?=
 =?us-ascii?Q?ExorUTTko4REiaDkM3DsggHnTPcfqVVHgXUWgHKmoKp6ibAb7DIUvG638sHT?=
 =?us-ascii?Q?PyX8V+6EjGQro04GjYc5yvSARBFIMq+fT6sfPB+Dh1SD2jH9AlJBMB+UhFP9?=
 =?us-ascii?Q?120bZd0A86tEGhAFrces7jV2FZs432Hpmm0fDKEmogbEvOK1HX15cYB24x2N?=
 =?us-ascii?Q?JNnT880CNerfOv8PXOPkCtVG65+/mj8ihim2GSY8pWgI+GOHwbo8WwMLO70M?=
 =?us-ascii?Q?67o/aq332+NwII2nHy4t/plZ7l0crbFhf+CARa2Dw8PdtTWMviLDsUv33ygC?=
 =?us-ascii?Q?qA9FPktAyVJkWr2pdu2ppKInehyV8WecJbsIjT/XcBL6HRi206y73kjY/N4i?=
 =?us-ascii?Q?9Y3LWQee+LZUzqnkTBo4okccb2P8IqoBFlo/F1lP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a22ea806-084f-4207-8405-08dd62d811cf
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2025 09:10:30.9812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BG2JfnjGMGL8Fq9dMlXqJL6cj8ixTH1DZydRnvC+6pfzdpllAafCKGSKTU9bCpGwHSaWsCcuXL+hMNnRH/72tA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6129
X-OriginatorOrg: intel.com

On Wed, Jan 22, 2025 at 03:25:29PM +0100, David Hildenbrand wrote:
>(split is possible if there are no unexpected folio references; private 
>pages cannot be GUP'ed, so it is feasible)
...
> > > Note that I'm not quite sure about the "2MB" interface, should it be
> > > a
> > > "PMD-size" interface?
> > 
> > I think Mike and I touched upon this aspect too - and I may be
> > misremembering - Mike suggested getting 1M, 2M, and bigger page sizes
> > in increments -- and then fitting in PMD sizes when we've had enough of
> > those.  That is to say he didn't want to preclude it, or gate the PMD
> > work on enabling all sizes first.
> 
> Starting with 2M is reasonable for now. The real question is how we want to
> deal with
Hi David,

I'm just trying to understand the background of in-place conversion.

Regarding to the two issues you mentioned with THP and non-in-place-conversion,
I have some questions (still based on starting with 2M):

> (a) Not being able to allocate a 2M folio reliably
If we start with fault in private pages from guest_memfd (not in page pool way)
and shared pages anonymously, is it correct to say that this is only a concern
when memory is under pressure?

> (b) Partial discarding
For shared pages, page migration and folio split are possible for shared THP?

For private pages, as you pointed out earlier, if we can ensure there are no
unexpected folio references for private memory, splitting a private huge folio
should succeed. Are you concerned about the memory fragmentation after repeated
partial conversions of private pages to and from shared?

Thanks
Yan

> Using only (unmovable) 2M folios would effectively not cause any real memory
> fragmentation in the system, because memory compaction operates on 2M
> pageblocks on x86. So that feels quite compelling.
> 
> Ideally we'd have a 2M pagepool from which guest_memfd would allocate pages
> and to which it would putback pages. Yes, this sound similar to hugetlb, but
> might be much easier to implement, because we are not limited by some of the
> hugetlb design decisions (HVO, not being able to partially map them, etc.).

