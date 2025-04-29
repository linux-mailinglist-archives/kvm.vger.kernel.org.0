Return-Path: <kvm+bounces-44629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BD24DA9FED4
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 03:12:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B4D171A870BF
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 01:12:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 618B517C211;
	Tue, 29 Apr 2025 01:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aKoKU/Gm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E11919F40F;
	Tue, 29 Apr 2025 01:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745889110; cv=fail; b=ALb+2P2UxArgxnBgnbTZydIsmwuSshKIGDku93JNYUWUrPzLES6BBi0WHey+rPpLAlt+8mBWMy5qHC/Rd6RE5PDJSjzCdp8X+GP+pxpZx32GRF6Z00Cw91eMDzOcE39AusAJ/QvoELRPOZrMeNuwcIhOowSb7DVewWDyWJbGgeI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745889110; c=relaxed/simple;
	bh=+4e24AFNh9DYJy1E/cdu24Xs8QAQCzOKGMZlaF7Qgo8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=m4tKH4wdCNkDfYhuWPu1H/0pDD4M3PqTknHVS3by2HFNGatPJqigYzyrBq755yx5OTcghpKJ43vhRhuuRrLpA8BjuZugP9DSvsKJcpspImrxEzPkrBUN5hzPJmg/71UU7muCrKn0FTHKNZNTXD2I5NdM05bIwFZaMQZfa+7fWrw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aKoKU/Gm; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745889108; x=1777425108;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=+4e24AFNh9DYJy1E/cdu24Xs8QAQCzOKGMZlaF7Qgo8=;
  b=aKoKU/Gm5A3tTGTBHRa3w0TsmnO+sjvW/91O7EgVvUbcNBiXkRELMTn/
   BBrPHAKfDjCfG/lbJjSqTJPVnGMjKsTIEsvHeUsQeBUtpB+ZalBMi8EgL
   mHp+cuiJBEHMMaqYg4tns1flm56Tld1tWrwNvh6x2BLUUKHQQGn3ow78V
   KGtxAFwsiLvHddwI+O8P3Y/Od42KdLbS8dkN0U5jksigGktinls66d+2s
   ah270M20HG/Jsu8TxKcUgE3TtSb9cN1sE7KXzrWAfiSGRAYSTsCvjHpRB
   GIH3tsufZPbh4OHhnD97h27XcdmPL1LL+qGRXMigQtTQoth31o5pMpDe4
   A==;
X-CSE-ConnectionGUID: 09JvnZw1Quit3ztTOqRYdg==
X-CSE-MsgGUID: NsDdttpBTxG+yKvrdmjegA==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="58869181"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="58869181"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 18:11:48 -0700
X-CSE-ConnectionGUID: HwcTHV/eTJuFPDsFwZK4Tg==
X-CSE-MsgGUID: cUcnvOdZTnami8EVNbO8UA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="134636998"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 18:11:47 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 28 Apr 2025 18:11:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 28 Apr 2025 18:11:46 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 28 Apr 2025 18:11:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GD+WretoL6yaxPCE+n3vCjq2ijUHKpoiLMuJ7pAAHTA1UIOU/cL2vEMC5Jiilt8AtWOqmlpCFb9jR/ELuYfpldJwqH1QsF0VQy5dTM7Wtip9tr0gEuc8ZMVr6JXmXp63ClzN6JGiH+5gVmdmkZgvunsE3ua11wCyy3j+pXinZ9Coux3U4Fa+PMJSsz66LJ1C3+MQyb0odav57ao5eY7tC/D+znNO46PDHED/Bc5y9wA5j4xahvXjCH/UILuvPDOFPKWu3JrJbtxI1xIKuv5EQqqF41FEpEOzYc7a7utgU+GkuwHFF87F1BU4SDED02TysGxrPiMSP1cwQ+YG4WssOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gNbIoW79XRq6xAJgH0Ia4XgprOCOpe8EK7SeYu/Hf4k=;
 b=fN0sL/r6GIyhL7Lka3JC0FN7FiE0VyYJ/AV9WQzLziKW/uITQV023Lu8hx4GL6cUvlKZ0kFy4kpg9x3yPdoEmejo/8dFcijwKcUokGxN6LRY65QPRk48p5aDeMg6fu4EEelr2VAtOHgGqbpl8ns+fv0spHiKsCzjBh0Yrk3ymg8H0y070t9s4JXh3KeWPO+dvliX30oh2HeVzEeV46FIoR4VIF58tW3NFc45ga+FOqPKESNKGpj+ZqglDIIYgvXESQWdAvkwFCQ4tztKXYBtUE6GBmaYYTOUN32QOFRaE/Pc1ovi1dNHilWhHxwDGN1ntFdaR93u2DcvzIZKZ+16dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH3PPF4E874A00C.namprd11.prod.outlook.com (2603:10b6:518:1::d1e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.33; Tue, 29 Apr
 2025 01:11:43 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 01:11:42 +0000
Date: Tue, 29 Apr 2025 09:09:49 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Michael Roth <michael.roth@amd.com>
Subject: Re: [PATCH] KVM: x86/mmu: Prevent installing hugepages when mem
 attributes are changing
Message-ID: <aBAm3a6ovCQzB/1/@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250426001056.1025157-1-seanjc@google.com>
 <aA7aozbc1grlevOm@yzhao56-desk.sh.intel.com>
 <aA-VrWyCkFuMWsaN@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aA-VrWyCkFuMWsaN@google.com>
X-ClientProxiedBy: KU0P306CA0082.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:2b::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH3PPF4E874A00C:EE_
X-MS-Office365-Filtering-Correlation-Id: e584f2ae-65f9-44f2-e122-08dd86bacd82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ySpqwqUiBtgMJtEHyCZT5sJCWrZ3D9zqt77iNa3irca9w68B/omkKrtSy3L4?=
 =?us-ascii?Q?jwpKrY/c6+TJk8ed11qcs3xBC8QIBd4kOmQiDtf/5/giwpXoJeGh46vELOIm?=
 =?us-ascii?Q?IPBgM0AL7xRnYYTbvgg3XJ1YH+FVRM53gA3kDtNeIukOsRWtyQHtmHE+zafb?=
 =?us-ascii?Q?M8dmj4JjcAZmRD7MpbZyIRypficLWUZku9L3zNtLOGU4GpsRa5o0FIO8ETuj?=
 =?us-ascii?Q?PDa1sdc7q9WyGU6hY/vpPw2wl+oY9wZBHP/uyYIjhaWa54c9hC3taBEycSwq?=
 =?us-ascii?Q?HINm6TNJajZc88alBxtclAjO/ZIebRvokYN8PkUH5KI3mXkBqbY3fGaRiTzz?=
 =?us-ascii?Q?PU9G1AfYPXUQoFTSQeU+yb50TOpE1Yvlfa8fk+woOofYQaX1hnA6+5LxRsQ2?=
 =?us-ascii?Q?YSmCkDMnQop8mN6I9c9AXze1VL9VXTirLRLfK+t2LHJhaO8nUFA/Cg8VW0OQ?=
 =?us-ascii?Q?rGoy9S2jRPgK/fgQKKy8JCLek9q9kczDV68oTft0sL//H+dz6vL2Cl4DdmRg?=
 =?us-ascii?Q?T2KDnjHprKUqaAJK+39lnr0Sd/voCSrpTx61stEVvokhLj9xd1QNNCsjIWQf?=
 =?us-ascii?Q?aVFpQ1YLow/6aUuHIb3lFdlUjNKzwldaG6ONOmiC2I2zfybgD8zips1IIuQm?=
 =?us-ascii?Q?1HqSxjnUb3cZ3ahRQ2EiQSf0nCHfhzVpAJS8hLU3oa8WbUjQnOwLWbh1stRV?=
 =?us-ascii?Q?dKq1iuSvXBpcqN4cuzlw07nUwS01hFmdP+gpkGBLkc+NhqNTFbnVTmq/Gc2c?=
 =?us-ascii?Q?l0UX5Ds03kwa93w7lHfTV0QjjGSnjyn1qvf2Uv3VG293s3Rw0/fr+nJaQD8R?=
 =?us-ascii?Q?tzAeYawCvqH+8a+Uh3V1lwOQEEwc/fCWoYzRwmdemWvVnrVIIFG2Iw+EGeQp?=
 =?us-ascii?Q?z4NAXALf9c6BBDZFT2cIc4yxpvwWSKcobIiXBtWAEqtxrvbLs6/fGcXzWj4s?=
 =?us-ascii?Q?e2TotHvqJB2+ChZzLhOvG1RmjubvVaR7XD08srqXDRX+eeq/X+5HsuOJ/mmg?=
 =?us-ascii?Q?yEaCgeQRNlEJRXwq58+ZPvyFpuYr8VIQlvrb9tJ7Y+2BfIG9Cwpq9lnuD/ou?=
 =?us-ascii?Q?xHwe/6rOYtecmJVLsNh9VlUQtlHvHTcuwG/TFVZDWWZ/QDJD2wzul3E/6uTr?=
 =?us-ascii?Q?WRKQ6YtkBkpfnZvZ4nV3nJlPrFLLrhtU031zku8NCfSTecI7QeRMr2dTchNT?=
 =?us-ascii?Q?2dQ2DwuhXp6TxgdoUvG7urlb4TtUnYOFFHBalrmDltZpyH8+LwU1Ltk2yN7T?=
 =?us-ascii?Q?V4SxzppFpguNlkNlBX89xqWnM+RWckbzG+N/e6uhxZa9D4WXYE+lmJtxWWgb?=
 =?us-ascii?Q?Yfr2TNFoPwtjgQSaqB/rLOvZoVg43afVNRh0ogkyX+B5sVFOHG046bTu98lV?=
 =?us-ascii?Q?l3w+GvV0RFNxwjxkkHI7VU+xaOEzC1VulNIVY3SjGYyk2QVbGQbModlFoUNs?=
 =?us-ascii?Q?UHqh3xr2ULc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cVyKGKEUzPMIkqIBlLdVj6MpMfclbklWco3+RtlhmNN+NMiBje78yElOWBks?=
 =?us-ascii?Q?UANv68Oya2Ql4+LjbTsyymsGiPhP9yzrN+5nSpA1KhGC7WROa4IkI6Ntk4bc?=
 =?us-ascii?Q?L3UWO5vOhhGV/QABBPqZQTlRjJ8NtVoNx7W2EDbkqd/1z8Gg3PCDo42KSjHi?=
 =?us-ascii?Q?2F0SE/gx8AaUOGDzlwnUH2gcucfwU1l0EM4lUX+JQs7cFx0rNLQV+2ldCkbY?=
 =?us-ascii?Q?DMteRpWE+ELzBM6syRkAfSYRL/D+F2zdIe/lzvjjCBofKloTf7b9SIHAkAJh?=
 =?us-ascii?Q?rQxFgVmfEYOBGwYwtVSzfr3shZ6RC/PiLf997rM1B1YB3blC85JYoqkoh0wE?=
 =?us-ascii?Q?CPewvkvP9vNIJFBzVjgyGsaK4fap92AFOQr4AQlphQ4PYIoGMD7p8gSwIeiA?=
 =?us-ascii?Q?Teofkgb5iuZXO4WMNw4EYuuUTEUJkVjVr+iehlIefWRG/qPz+FPnpDdhv8i2?=
 =?us-ascii?Q?QOo+3L8Bae1tcsCI2JLy3gfsgJkYW6JFGej3oGK0AylOpDzMaKhMTYu9qGLY?=
 =?us-ascii?Q?r6AmSH0hfXht+49H5eQMkycRNERXCIbshE7AEevFsWBaFuOOSk+/WKn8AcLM?=
 =?us-ascii?Q?ddZlk+XBLz+VQskUClHbWGj/1mJoiaeKaythv/dw8xrYfhE7dYVgUR8IXSiS?=
 =?us-ascii?Q?PVGpABkqKoSsINqG66r3sI+XaZ2dvZ5cCwYJn9VHqsKaNtsx/ezmHKCY994R?=
 =?us-ascii?Q?7152EhEmIPIViX2ju0yty+fMI7Es9A6vY+82kcAUxleRbHVX50GMncGWq8EK?=
 =?us-ascii?Q?lFVq+yl2wfOFeWvGvzOSApCceYJ7CWt+RPPM9zxMV+TGiDhVxIvplxjlV+XL?=
 =?us-ascii?Q?KCcizWh1DT+HfM8Ae/njBPdXmHJn0mWP5l+21587/4VHr4/Vn4Op1tZP10cW?=
 =?us-ascii?Q?AwYkxCuSdChZUkmu1td9XRaZhlynfR6AP7Hir3MJMqddFvsN1YzoM+B3ReGr?=
 =?us-ascii?Q?V4DeC1fM6JdN+iE5t6xQtdN6coiVm1rCzwqv/0Dy4v1+HErysmx5oaxezcCB?=
 =?us-ascii?Q?tUA6OCHNGv0L5aEcHZ8kg3KyeWEvYDhmZKajwkTVA+tbM2/NzjF9GZ0jjkRO?=
 =?us-ascii?Q?QMw9lqIEq4TZa9nGq+AHNDb9HzdJbiRFF9cy4RHGucSssGi1CzN/ZkhlT4O2?=
 =?us-ascii?Q?mzGDyqVPdrju59W1osQYpJUU3QBe0wawKlml9CsZLkcg4fakVSqTOhCOF3Gi?=
 =?us-ascii?Q?M1u9stsa9+NzvPanpqBhxqdDR0w5NUb5JsJVtIKTLoC6bHksRx1NBc6JSUdY?=
 =?us-ascii?Q?0vcmdwCaGzyIH5gn9QyfFnVzdsrWG0dQ54eNBcLPCbVrLHkT0b0sOPnDlkcF?=
 =?us-ascii?Q?BJXmGJACgADtCjn9ioXlLMu11SzAy/8arGRO/j/wxEfGh5oGOsA7YGn3B4FM?=
 =?us-ascii?Q?U8YUEo7B0YMcXsG66CrdJQBPLjVO8wLG1DQUeP50wHIJVQ1KkHaDJYBcJbFM?=
 =?us-ascii?Q?7IkWSuZtokHH+lmg6d9Uq324l8OY/pQ+weHmkfeyRKgWN1/6uH1tDzjXSL/N?=
 =?us-ascii?Q?oVfYX8i4NRVSA/ATjGtC//U9weLoXPLW/RKlEBal7stzPxKYx8LeEBbH2NzP?=
 =?us-ascii?Q?mWYNhGG45CVeX0pUEpsvAu7+AjwfjtdNfrdbsS/a?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e584f2ae-65f9-44f2-e122-08dd86bacd82
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 01:11:42.8366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A9pSQ6bFrhJDnlaHyjTVH8iMoPz324Bs5Oubm5yBNrZHH23Ag6X0FgL6LnazMU0u97rtKd1AvMqv4Ajj3mOCXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF4E874A00C
X-OriginatorOrg: intel.com

On Mon, Apr 28, 2025 at 07:50:21AM -0700, Sean Christopherson wrote:
> On Mon, Apr 28, 2025, Yan Zhao wrote:
> > On Fri, Apr 25, 2025 at 05:10:56PM -0700, Sean Christopherson wrote:
> > > @@ -7686,6 +7707,37 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
> > >  	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
> > >  		return false;
> > >  
> > > +	if (WARN_ON_ONCE(range->end <= range->start))
> > > +		return false;
> > > +
> > > +	/*
> > > +	 * If the head and tail pages of the range currently allow a hugepage,
> > > +	 * i.e. reside fully in the slot and don't have mixed attributes, then
> > > +	 * add each corresponding hugepage range to the ongoing invalidation,
> > > +	 * e.g. to prevent KVM from creating a hugepage in response to a fault
> > > +	 * for a gfn whose attributes aren't changing.  Note, only the range
> > > +	 * of gfns whose attributes are being modified needs to be explicitly
> > > +	 * unmapped, as that will unmap any existing hugepages.
> > > +	 */
> > > +	for (level = PG_LEVEL_2M; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {
> > > +		gfn_t start = gfn_round_for_level(range->start, level);
> > > +		gfn_t end = gfn_round_for_level(range->end - 1, level);
> > > +		gfn_t nr_pages = KVM_PAGES_PER_HPAGE(level);
> > > +
> > > +		if ((start != range->start || start + nr_pages > range->end) &&
> > > +		    start >= slot->base_gfn &&
> > > +		    start + nr_pages <= slot->base_gfn + slot->npages &&
> > > +		    !hugepage_test_mixed(slot, start, level))
> > Instead of checking mixed flag in disallow_lpage, could we check disallow_lpage
> > directly?
> > 
> > So, if mixed flag is not set but disallow_lpage is 1, there's no need to update
> > the invalidate range.
> > 
> > > +			kvm_mmu_invalidate_range_add(kvm, start, start + nr_pages);
> > > +
> > > +		if (end == start)
> > > +			continue;
> > > +
> > > +		if ((end + nr_pages) <= (slot->base_gfn + slot->npages) &&
> > > +		    !hugepage_test_mixed(slot, end, level))
> > if ((end + nr_pages > range->end) &&
> >     ((end + nr_pages) <= (slot->base_gfn + slot->npages)) &&
> >     !lpage_info_slot(gfn, slot, level)->disallow_lpage)
> > 
> > ?
> 
> No, disallow_lpage is used by write-tracking and shadow paging to prevent creating
> huge pages for a write-protected gfn.  mmu_lock is dropped after the pre_set_range
> call to kvm_handle_gfn_range(), and so disallow_lpage could go to zero if the last
> shadow page for the affected range is zapped.  In practice, KVM isn't going to be
That's a good point. I missed it.

> doing write-tracking or shadow paging for CoCo VMs, so there's no missed optimization
> on that front.
>
> And if disallow_lpage is non-zero due to a misaligned memslot base/size, then the
> start/end checks will skip this level anyways.

If the gfn and userspace address are not aligned wrt each other at a certain
level, the disallow_lpage for that level is set to 1 for the entire slot.
This is often the case at the 1G level.

But as kvm_vm_set_mem_attributes() holds write mmu_lock for most of the time,
preventing fault over a larger range for another short period looks no harm.


