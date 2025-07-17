Return-Path: <kvm+bounces-52809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 31284B096D8
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 00:12:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E707E4A23CB
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 22:12:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B289239072;
	Thu, 17 Jul 2025 22:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="erodILR6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A048D1EF092
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 22:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752790364; cv=fail; b=onyElZROsqbuXlUkXSdJ3uLcN0J/Z4zY9tQUAoDzudWZOKDtwPODLU8dpn1m/AwRFbfA8uDNHxJE9U+EgnVIshQWWC1e8EHSxhDdpEeZcWk8GfdjugseFuFq18Npeq6u3btf8z+ptRK5TneWplfBOWzvMFaOqsctrLYAZukC3+U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752790364; c=relaxed/simple;
	bh=sPnRcTRuxjdXnq0ljVqnWVw3WqOBkzPhab0QSGR6mtc=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mYjSFZCr7enAdkEeBWSvXEJFJZpZpmfXra/rOkSZNA539goKbGYpOJ2FRoz5cZp+9AyEWrSylwgdY6vqlQupI6P4sDcNDiKgorcQh6Vr9rLpHrr5TagfP5Ui75Y3bRfUfwW3igsK06Senp8CXNWszV39isC/e8xYs8pCZm2ZtJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=erodILR6; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752790363; x=1784326363;
  h=date:from:to:subject:message-id:references:in-reply-to:
   mime-version;
  bh=sPnRcTRuxjdXnq0ljVqnWVw3WqOBkzPhab0QSGR6mtc=;
  b=erodILR67cgy2FnbCAAjPUHnmp8HsXXydrHym5ysmg58zAW6g6JZsP+c
   7vr1DlX4et5MK1A4lJcMUBo8FuhIc9s8H1nPTvTbxVmT3TJiPlniY4Ihu
   qQiMqWPeH1YFX8bo859nZzqVkrd9Xllm9Of10Nc/3sN/a1s7Gbn/wiZI2
   bC3NheMn9w442Sr4/9cSFWbLc87eGt/cOVY2qy8kTGUdKeZJ4BES9RrAp
   sJ6yOMYJEoobHmeXrLbV/k5j10vQLLBQEwU8x/1Wd9Z3zQ6AV/UfeRRJq
   rqALucDeWrAv9XKJp0cjV1LtqDgqpfh6A2UXXhhcbGrSTsU/COBT62vl3
   Q==;
X-CSE-ConnectionGUID: 8FX4RWAaSN+6v7YR09J3gQ==
X-CSE-MsgGUID: 3XctRx0XQ0KG0mqh+pTUgg==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="58750705"
X-IronPort-AV: E=Sophos;i="6.16,319,1744095600"; 
   d="scan'208";a="58750705"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 15:12:42 -0700
X-CSE-ConnectionGUID: sbt2XZtVT9qzxXDEC3wrqw==
X-CSE-MsgGUID: UrothZHfQHKjdcGck9ZAYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,319,1744095600"; 
   d="scan'208";a="195043000"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 15:12:42 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 17 Jul 2025 15:12:41 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 17 Jul 2025 15:12:41 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.87)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 17 Jul 2025 15:12:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rw3LhluPH9euxpYb4hy8/BZTMKos0mv0HQ1wqRd6150eDnLn0YmcrCp3VEXRhqqZ1Ffe/JcmuehkixYQz+UKaaBd5mF7W1l2Al+ICeJz8dYAhdmR9LM8ZTHySXLYdU/9g6vpHbO1snbPOhgyGxzBPWpRF2vhqdlBpipgMsL61rsasl/EF1cv9REqjqADtj9K2c6tDZZNK6AP1R8fnjEueRTRKNosWiDXsZlmVLHXTBu3ryqAvcJPdHR1Jem2V/dmKGBOrGgn36DyfILK08zm4LnxhIAKejEt8QE85L+Twhkc+DmPM86vsyZzqCldJwbueBcmLhFI3o6z+2J44rCmPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xt+jku0+JLq9zi2WWsL7cdK6cPdmcVWShdSo6RgJ90E=;
 b=Tk9PHKeBgQ6AqB2GVITP+VnY+8Ynl9dGEtbShQ7dDn3f5ozRfGPVQqVJnMRU5dnGcPESk077+hgxO+ZRfCLOwikK402QGxWQBm5OOsqzhuiA6tPpYc+Y71Eh38TlJhbGLkXZcKgWc8fNIBfm+cfX0bbsgnm/rCkCmJ7JLFknh5HAOoFOnJVpeQwgHy9MXqvGDn+LvqW5Cm+u+nwzofYAs9JfBU8ajfzhc+2GQgUnpz4i7nctPCYQDGCyfKWNXqFLsdWGfJBd/WxDaRDXcdTMGngszWzorrV6PSDVwx7bFOVVkA/2cO+FDatZJBzF4OlsNYmjmJ6YQIbpawrAbcoQxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by CY5PR11MB6162.namprd11.prod.outlook.com
 (2603:10b6:930:29::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Thu, 17 Jul
 2025 22:12:38 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f%5]) with mapi id 15.20.8835.018; Thu, 17 Jul 2025
 22:12:38 +0000
Date: Thu, 17 Jul 2025 17:14:10 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: David Hildenbrand <david@redhat.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM
	<kvm@vger.kernel.org>
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2025-07-17
Message-ID: <687975b253bbf_3c282b2941@iweiny-mobl.notmuch>
References: <044a8f63-32d9-4c6f-ae3f-79072062d076@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <044a8f63-32d9-4c6f-ae3f-79072062d076@redhat.com>
X-ClientProxiedBy: MW4PR03CA0305.namprd03.prod.outlook.com
 (2603:10b6:303:dd::10) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|CY5PR11MB6162:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e2785ee-029d-44c3-f189-08ddc57f0a52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?FBy0FAxCWiOH2FDFwQggQRB/BbU1I2R2XMVPHgoGaCzh3WKc4p143m22p2MV?=
 =?us-ascii?Q?Yz7V85hwA2IbZwOBJRd5+5tK8J9XK1pyXbrbGMaUwhEUNWbLifLKRUqdkIie?=
 =?us-ascii?Q?41L0NvrcwW83tEZfp5+I5xQmP+2fmKh7XPEvB1MaUpKGHdOA58LmY6EZUNNK?=
 =?us-ascii?Q?cvlkPY7VfhBCG3EahPU2wTBTNWOw+bxDJmmbbz8TGarqrVcQ9l3+6nVlMTCM?=
 =?us-ascii?Q?FqdAdhrZJwoLDl+gtw5xGwHH7+jPpJlO7vPKZKhc9h4poQ7cItXZBx2+id9N?=
 =?us-ascii?Q?bYAJw69IjdBg0SL/yjBCmQufhcklEDBDjlcqanZC2fyCfPMhK1Kf9B+GBcxz?=
 =?us-ascii?Q?HcBZA5ylQvyxxvThPMxvwnawhyM6y0PDD+QN8nMP5GRpx1+QKbCvxoz+Gnef?=
 =?us-ascii?Q?V93YlVTsGNXqRlPnMffsTHduXUxyoAhXg6ptLmuAJbu99oqNg2ZyuUtMNXVy?=
 =?us-ascii?Q?zGo4RSb/nhcNwYE+ZO+tM1b8vEZ04EXQtsT/y95e2RTa4CzeiZ1CBw9UEMVu?=
 =?us-ascii?Q?aVhzFf/WmWkl6dnr/hhGCZVhHEWCfAn/Sd15DD1+q/WKpu2ats0EDZLUyH6I?=
 =?us-ascii?Q?PnqzH5CcKSaAEQ9T64C6xtA/BzvflHaz934/o9j+/oRRn5xKEhpy6vMqOXL+?=
 =?us-ascii?Q?iGNemqxwU6BzyUugeXimOzyJ5nETELjh6H7STlCGtR47eK2tVUjmFe8f57SZ?=
 =?us-ascii?Q?p3UA7drej3BpCdcSk1cBAnp2/LFAIWAEMeZWCeJhN3SXUH1DI4aggRnHwkWS?=
 =?us-ascii?Q?QU5lEvB0QTQ4Gck2LSJcmaiP2onBXOCG2tfyQOuLqBhcrclI1RShPwbFc/h0?=
 =?us-ascii?Q?w1g3FySFqXhnROSBYxpvROQneyHOi5rP+HpJhp/GsW1sgU2p1UlkQutNuW91?=
 =?us-ascii?Q?27HZNtOXsz7RF6hO+qIof/9kGNMDPcx1oZCoz3ZGriZ4TZW8nxpxM+XmNfZJ?=
 =?us-ascii?Q?v4mfXwguW0EcsJmGq6SKuKqwydU2b6H+IQH0/PMxQ8NQ3JwwTJ6Rw5LYw0Ac?=
 =?us-ascii?Q?wgcZkNi9SsGcZdmTr/u45rmScU0ys6aiB7hXnNMLguYIFMR0RDRfWCKEkFLr?=
 =?us-ascii?Q?vuYKVpc696SwaCOjZ+dnN5+NX5/SkrzaMikH50xF+cfRBe5Jqk91xuZzFzjX?=
 =?us-ascii?Q?HWo4QqSdf5ymC/g0abr1YWr9tp2zkVDaPGmNoT29ued1N3V6VK4rKlrH7e83?=
 =?us-ascii?Q?bG+5iVg5vbSsDZ71vZnCLZnYwzzWNLrOY5sB8i6hCfCZBDsIjQc+6xXoKCCt?=
 =?us-ascii?Q?033ShcS28/nghsTZroAqshc9ywkEjDID32RTjHRLTnQGyVtXqxupfgE7B8Gz?=
 =?us-ascii?Q?EKY44TVHpwIJRaM6UlBQlIbEmjgJf1L32QuXVEjVo3yViAtMAwiTiGDi8tpH?=
 =?us-ascii?Q?DCDt8Bg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Etmkvqa7W0tl9+2hciqpeRD5Prpps5/Thvn/SyvrI7VDIsoDQ9PIU3yRTbx7?=
 =?us-ascii?Q?1dfs9cQmdB7EuCtEqMtOerDuAaU85deTzqVJrevMTw9AMiY7tzHlZkiLlMU0?=
 =?us-ascii?Q?lfMf04qfMcejk6f6ei8lqbZgca+luz/2nhGSY1iByXTwgfGRDJXs2ibPoape?=
 =?us-ascii?Q?4wvsxsxSS8UCvCU4WrXYSlify+fJ+lcU8kQP6OotjVVCAJFEzCUR/4F8LSvo?=
 =?us-ascii?Q?5JwMyEMfnQ/mylRf0RiZB+8/0UbkU0zmk298By859HI7HM7sYx+yzoaM8Mnr?=
 =?us-ascii?Q?IGQa//CIOxGo9VddlPsLz9AaLMHAvwQ0k5a0GvXsKDSO9Fed0RbEBRD9ESOs?=
 =?us-ascii?Q?m+Z40QVYZ2isyq+QpH+vDItN+aE0Px8ZS0i6CErV3qQkjIkWG6dtXHW6JCJd?=
 =?us-ascii?Q?jqDxBpOlGIaxXiJLj4WQH+ltIsCY7+g6rSdLXBIEFtEPo7xwHE2f7uTaWRhz?=
 =?us-ascii?Q?gbGcNa/k1ZSsnisMlZy6nbDNdOy7pWWrHnS5RtOV2ULEqzS/hk6606+27Roc?=
 =?us-ascii?Q?WA7ND1j+AtgmHhZdqEyqjcxQDW7rTM9GqUDzVUBz0JDrXAa0PBh4T8RRr190?=
 =?us-ascii?Q?n0CS45A/yzCwqdGXQbsE/dsGZug+ICEL5xeOWP0FJkbLnWDNhXqJclb2IMMb?=
 =?us-ascii?Q?JpCsSzMraPbrWvdn2ekh9cUkoCQVAOL7UdGsIcjB5zcUhnumTPZ+XNLBbXlK?=
 =?us-ascii?Q?XWMqrwTmm4BOe3irXupCan1whtUYSJQ4+horqfsLtsUuZZgUhxCzo8hIC+w1?=
 =?us-ascii?Q?uADWy7jV1ZKxVewE2uLZfoyiGpl+hcqUjdfAODXyyJjLroHYBa9nVNLMjvr8?=
 =?us-ascii?Q?ZKhH9ZUYjbyF0VuyiQ919m85wQ/8SGWSn8WwOMPHMF0Z0XfA1QZdy5Ac6bnQ?=
 =?us-ascii?Q?SkLtJDe7lVWQ2JnATZgc+CgZ1AIBKLOfWQaLFqLUH17Hoc6Nx2N88XuaN9EV?=
 =?us-ascii?Q?Dlwp8gfFR8Pz5SmmZMrKnNd1O9iqrKyCmozxkaYNu43oeChIuTu6l6dtcxJh?=
 =?us-ascii?Q?m8hOxV+/BrN8exHJwkgTJLd6aJzzp92EpfosKeshe01B8AFJuYR+HGrA78nJ?=
 =?us-ascii?Q?dltFy+3Kj0FRqAf77ITYCxdAgOj7aMwfi7HtldwtBkYXTeEhrwlat7Co7ojY?=
 =?us-ascii?Q?QLXRO6f83Tew30bBtJ5qAI96dCVU/4/wRA5W4fADf1Lw0PTobz4qtN1RoT4c?=
 =?us-ascii?Q?uImcn8zRZS/0HmuPCKTb99XLxDGsGdW2Cd2OTifCL9bMPk4UXWwAwFCZLC8I?=
 =?us-ascii?Q?DaSQUXXwlz4HdKtRxCBfMUnMbIzB5W5DqVWfd1mJYrzKoUN9qp90bNU5qpYL?=
 =?us-ascii?Q?54doFVIrrsX7VSBhm6uIaxtFhrsQQw0dpIL1AVJwfXG9DSNYosHnEqq8WONy?=
 =?us-ascii?Q?FF0FkKW6XJjJ6wrZ0tqrhCZ0EL+FpMjTC15W+Wy5NinJx7gWHu54y45Bp1jZ?=
 =?us-ascii?Q?b4LyLbKnMnc1fKg1Js9COL1R/Z3cytEf5Ew0lhSCbgCJlp44o/AwZPL13vZW?=
 =?us-ascii?Q?BBob8n+n2A0E5bSDlFAkcJNNH4sWbOZN2Te14vqBtVQYw/EXXwbhsEuD0QDE?=
 =?us-ascii?Q?hDNLX15N3LIyFJOnoYaViTzwyRWvLe9cxx2zey0M?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e2785ee-029d-44c3-f189-08ddc57f0a52
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2025 22:12:38.4127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /XSxaxFp2IxQWps4mvXvN35MOkWp7KXl93LT+l8gKn0Ng1H3ZBFlsNojOlNPMo+C+P38H/TzIyl/V6zGFgDCIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6162
X-OriginatorOrg: intel.com

David Hildenbrand wrote:
> Hi everybody,
> 
> I had to move the meeting by one week -- I'll be out the next two days 
> -- and decided to send the invite out already to highlight that :)
> 
> So, our next guest_memfd upstream call is scheduled for next week, 
> Thursday, 2025-07-17 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

Did I hear correctly?  I thought I heard you mentioned that we are meeting
again in a week?  So was today, 7/17, a one off shift of the bi-weekly call?

Or do we now meet 2 weeks from today?

Ira

> 
> We'll be using the following Google meet:
> http://meet.google.com/wxp-wtju-jzw
> 
> The meeting notes can be found at [1], where we also link recordings and
> collect current guest_memfd upstream proposals. If you want an google
> calendar invitation that also covers all future meetings, just write me
> a mail.
> 
> In this meeting, we'll talk about memory failure handling, and continue 
> our discussion on polishing up mmap support ("stage-1") to finally get 
> it merged ... and whatever else comes up around that.
> 
> To put something to discuss onto the agenda, reply to this mail or add
> them to the "Topics/questions for next meeting(s)" section in the
> meeting notes as a comment.
> 
> Cheers,
> 
> David
> 
> [1]
> https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing
> 
> 



