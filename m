Return-Path: <kvm+bounces-1453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8D4D7E797E
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 07:43:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F3AA1C20E28
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 06:43:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E847363BC;
	Fri, 10 Nov 2023 06:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E4vBhNvj"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D71D1C2E
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 06:43:10 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC21A7D84;
	Thu,  9 Nov 2023 22:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699598589; x=1731134589;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=84hmqFlJ0/KqeHTUwsl0QgGg/dSDVg6Y9BR47Dgmer4=;
  b=E4vBhNvjcRx8VwhLexytdc1V/gw+A5818IsWiVBwblXE2/zHMI0BKicX
   0Csa7PPIuVxYcq+YzLervzJrCC5K2qvGVEafnJnO/ZxpPkPAHFpuBp6bA
   0sCOpBHKz+DzhUp0OzIU4uv9IWn51qLn6T5yvp0X2P9CYfNJzk2PLN14M
   ugIM+WiX/vVj92cdHV6JhYBkNLDzzRqRJ6SPD9joGh36/rG93iPHvhqhA
   y04MxWPHNzUWbZWVLvRE3J9cEAi78u064y2lyW4YVys/ZAmMGwtYNtaK6
   zsjW/bld/WyNoMXluLeAJh6VMofIyNBk0YobptKdPtS66U1zKc7iDbQl5
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10889"; a="454436341"
X-IronPort-AV: E=Sophos;i="6.03,291,1694761200"; 
   d="scan'208";a="454436341"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 21:41:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10889"; a="887265711"
X-IronPort-AV: E=Sophos;i="6.03,291,1694761200"; 
   d="scan'208";a="887265711"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Nov 2023 21:41:50 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 9 Nov 2023 21:41:50 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Thu, 9 Nov 2023 21:41:50 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Thu, 9 Nov 2023 21:41:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K2rKoqgTA1oCtft3oJceCmurX0Gs7XJlZka6cjoTlz9aRiAKCCsVu+7FouzWYwI1sMcWxkBDlqALdxsu81eopo+Q3VDAJ3PIojJsEJrE0vJNbE4IwQIbDbgkzEein56KFwjNH74+GxIi6nS90lMJ1hat2rPL4rTIWOKDZBAsG9MpDjWaI26kMXZJp4gPqfjPED/mvq0fFedWuLUGRLcaKSu7Cic3FCBMSbKEp4NkHcXAL093KC+KHf+dAAOwxPeQrA41ZR8MxGWPA/cMXxsiuYmiOezK9YZJa9hROaPXpbmvfo5xHkvZ/djlGm9AmemYeGgU4ZVetHqLrLLgeNNkHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2uQVHI+SMxd1sOR4XwnN0mxc1y+97BA2PSvzZUXh8r8=;
 b=b2PZrTQ7THxN1z7KhHNHg3RVZuzHLXrpw7d3X6F1l4AS/OCT+iZgILBZ/KbTyG2Aljgo2aMMWDzo7eSFQHBlZKz6ZpD85UX3esqmmFjhEhoET9WjDSbQF6PDdsgm+2jJ+m3zblnF7gZM+HVyjZJRZ9ONgk+UQFxkWK7QR12OJmIIuqlcR7Ccmeo5eCPJ56eU6lY6/bxQ0EcrYfTyi2YR1YJI8LYSU6XUpek3hnkZd1hx65x3rPtqJtk7UunqJDdhY5Z3PFNzfQikU79txadLIABRUgpRVxIlhsPsJlh+APN8F0BRZUsDrZCRIUE1HlKbMD1vnstCGciYYaz2AvafCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6392.namprd11.prod.outlook.com (2603:10b6:930:37::15)
 by PH8PR11MB6732.namprd11.prod.outlook.com (2603:10b6:510:1c8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.19; Fri, 10 Nov
 2023 05:41:46 +0000
Received: from CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::15d3:7425:a09e:1c86]) by CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::15d3:7425:a09e:1c86%4]) with mapi id 15.20.6933.028; Fri, 10 Nov 2023
 05:41:46 +0000
Date: Fri, 10 Nov 2023 13:37:01 +0800
From: kernel test robot <yujie.liu@intel.com>
To: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <oe-kbuild-all@lists.linux.dev>, <isaku.yamahata@intel.com>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, "Vishal
 Annapurve" <vannapurve@google.com>
Subject: Re: [PATCH 2/2] KVM: X86: Add a capability to configure bus
 frequency for APIC timer
Message-ID: <202311100209.zIaZqZhg-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <70c2a2277f57b804c715c5b4b4aa0b3561ed6a4f.1699383993.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SG3P274CA0008.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::20)
 To CY5PR11MB6392.namprd11.prod.outlook.com (2603:10b6:930:37::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6392:EE_|PH8PR11MB6732:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d51f5ee-0d29-4ca1-9d89-08dbe1afb9db
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HkPcmT+0l+owgpK6pEtt+d29pZt2icBgacMueN1o6WVKg3PjgCPWcs0neBJmd2VWUqRjppaPnP86vIN1BxiBv3MBp2mIzIFfdgAipHzkqMAdAxc+EBPqk9Xz5BbhLF9ccsvY6wewUBF7KPu0AyQrqLYu91Va2Cy3lbgQVjWblpkagQqXbxCCYkFfE7HfI6u+xXoMK6UTBmIA083L5z8aCAbPuMtn1Eo+zxZmOurIkQ722Y2fT9+IH7bKGCwE2j2sdh4JlVebWVZ3JCp0pDMHCXPaH7rBIIVy2c5h1kIyPSihZ3+UWqElCVM2oqSO5Zcn14/Yt8bRUPYwRkZ0bm5EXlJmGno9KK1owUE6ac1MNhpoRY21uS3PL71mga59lJwETXFpXyQJ2VVYMU+Tb+7NWWtez96ISOl6y0R4gNnvP4Ioq2E5FDdHyNFZOiOGjslyDMfDUqU5lpD2MGzQoL2uePhOMzo++qtowJ+/Lm8Ca5wpcaTcIwNLrtACwJrNWsjQFuClZPsbkrFwDEHFeSxW5sF2Tvugz/eDwl0eF5xhtuD98yK79Kvl4qgNJQXBnVsZ7S7ueUIBDx2TqGrX4pj/HQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6392.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(366004)(396003)(136003)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(1076003)(2616005)(83380400001)(82960400001)(26005)(478600001)(6506007)(6666004)(966005)(6486002)(6512007)(2906002)(8676002)(8936002)(41300700001)(36756003)(4326008)(5660300002)(86362001)(38100700002)(316002)(66476007)(66556008)(66946007)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SdwkIj5C/9h/QDirdSr+gOoenvzrIt0fXS0YdQeDnDoUqGeo81XJT/XVwD7I?=
 =?us-ascii?Q?KrQQrev2SF6ettPCu7q4/Qy2VgJjrZ9kNeXe/1psK5HAltk01jupomh6Ohm/?=
 =?us-ascii?Q?diTCBdmETZOeUe4fK/hvULwosLDMTOGl/kD72Jpue8BOZacjRiOQxksokwnV?=
 =?us-ascii?Q?X6z5I5cXCAdeSpcj235Es9eO4ArrXtce5xrT3XI+/4VT0z6gVVDyjwMiLKkk?=
 =?us-ascii?Q?eW1qtLZSq12raQmfHiRubrNnF5dwNhtGhzB496l6AdvFEU2wLqRtlaVhWQM/?=
 =?us-ascii?Q?z74iW2i0PR+LbmbhF4y/ShOk6M+92ZzTzpa38Blx343dL3qG3KtUHyaFohCV?=
 =?us-ascii?Q?OaNYHwpTsPYQj5kYL1oivCFR8Th8oiEdS0osDGIsTqD0OPIvS1fgNd695wbn?=
 =?us-ascii?Q?8U1jMI/qdctifuSqTXHIpwxtdLu7oCfMHVwT9kxONNKunuGxAAUnHXO/NsUm?=
 =?us-ascii?Q?sVGXkakSggmwJ4POqcrg3m/h6c3YErrz8nyyoPhSp5mvI6T8WzSVq/bG4S8t?=
 =?us-ascii?Q?esC8DKlLjuXspSAEkYN6fgO8TPvqHHCd9bPoihWZZoP2+inI6+c/23CTHJE9?=
 =?us-ascii?Q?W6DxT87AZaj08sp7F+ZnHhgG4WF6XrN3OGfsPDfiYVfTjcvbh5Aks3ixnwmb?=
 =?us-ascii?Q?Mji0SSX8rB6f7CGz/e3ynouxJSE2SLBnmdI35ep3fJZCGMWzlFqf/3Je9BV0?=
 =?us-ascii?Q?Q3+gqUSVAn8cGFWTKcKdxfFDLjhTMj5fcZWHi/LcdMI4jjT3gJPJvVGHQhRA?=
 =?us-ascii?Q?aBqXXCYlVeoCL/1IUtIyQ77ud9XhO78Quy9fkqh6+wvMQiisDib/66fo59A7?=
 =?us-ascii?Q?d1DcaiDNbBPa3oAvehJNwSmughEZDnqq3f+HFLINu1vec25T3N8DHFHbp7uq?=
 =?us-ascii?Q?6fprrfeFFUi5r1GloNte8e6xrtbsqq5bXR/z378YKYRkCiGkG9m5yzOLxVlx?=
 =?us-ascii?Q?sYfafuNQ2IrQENiHkLKg2HTpxgRId6NDQgLF9nwVvw1aBPtt32/ijOO5nDqY?=
 =?us-ascii?Q?lVn3LC6zlpkhl6cGvM+08gNGmHh6F9s9PyOmQTA2XDy3ZG/bEXsa70sZcGfY?=
 =?us-ascii?Q?j8IVgNRiDZoeH8asQowTOQCrXGfTdDpe/PgnHa8r/0002GXd0a9RRv18TBZn?=
 =?us-ascii?Q?NMM3goXNNWbd8wo9TEkIi09oFa0CIMxpVGlOImBnaeoPmyaveOyu4NB9Pasr?=
 =?us-ascii?Q?B4VrN3naDE1pyIAYOO9EKiBy+VA0Uj2V+7mvQQy2ZcJNGd1J2AEkWkoGwMew?=
 =?us-ascii?Q?nEam2D7JDFrpDhaY1zsq9B3PYxftFaqE8O1COofiOjKEpKuuW/qenCj7z05M?=
 =?us-ascii?Q?pCwrV3kjcMLhy2L+xIhS0+CN5Ro6UBXQ/5Ia3IDogL7hTg8ScnLr6HsmQGRS?=
 =?us-ascii?Q?Vrc7q0NXWjDSlkr0SVws+57Njz0l2W6pJRqc4j5K9gCvgVuwbxo5pzLkNkkf?=
 =?us-ascii?Q?DdXbO78DOrTIClZxuXQu3LNuenO1k+w4jQWWW1vb4OQFxeUkPt9PwUyeuc3y?=
 =?us-ascii?Q?QFdgQ0bsdAcB44ErbiMYc1RXnZKTJbQ8uFm0G6K/cfuOflVNNrHewSvL0oCj?=
 =?us-ascii?Q?mFkHMJmKfiWYCCJRAPTplkAkpR8CJ/v3XSVfVexZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d51f5ee-0d29-4ca1-9d89-08dbe1afb9db
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6392.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2023 05:41:45.8081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h+sW4rZ6F9023sNgmyCsQhrwAGaYI4tm/ZdlAm1LP4hRnr5ivfnTMv2jH2+Hu0pEya29ppOREE0hzlGHwxLH9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6732
X-OriginatorOrg: intel.com

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on linus/master next-20231109]
[cannot apply to mst-vhost/linux-next kvm/linux-next v6.6]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/isaku-yamahata-intel-com/KVM-x86-Make-the-hardcoded-APIC-bus-frequency-vm-variable/20231108-032736
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/70c2a2277f57b804c715c5b4b4aa0b3561ed6a4f.1699383993.git.isaku.yamahata%40intel.com
patch subject: [PATCH 2/2] KVM: X86: Add a capability to configure bus frequency for APIC timer
config: i386-buildonly-randconfig-002-20231109 (https://download.01.org/0day-ci/archive/20231110/202311100209.zIaZqZhg-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231110/202311100209.zIaZqZhg-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yujie.liu@intel.com>
| Closes: https://lore.kernel.org/r/202311100209.zIaZqZhg-lkp@intel.com/

All errors (this is a 32-bit build, new ones prefixed by >>):

   ld: arch/x86/kvm/x86.o: in function `kvm_vm_ioctl_enable_cap':
>> x86.c:(.text+0x1265b): undefined reference to `__udivdi3'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


