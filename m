Return-Path: <kvm+bounces-24098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FDB79514B9
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 08:34:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 88E651F23635
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 06:34:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0181131E2D;
	Wed, 14 Aug 2024 06:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZGJid9jF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4DA60275
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 06:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723617289; cv=fail; b=Be0CIqhfETgxEEKu97E3mn372sKtFmOJLWyOVErMR0ndn+veCbxlhYikp/MrlJNk3vUmC7lgteHApz6qkobPipVyJabxF7ii/xS7s/SXLH7r4dmxoTo76/o1atrvWT9bY15zePoq3eFQusM2jEUy7k1Eep901SrG7R3xNqmfHfw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723617289; c=relaxed/simple;
	bh=WpXPcx35BuQ+SlkHkwnyVw+tiP2AD4vHyInROmfia0o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oHmuXyK9aV6PboSjB7cWjaKtsu6IqkwLEu5CaF3jVBEe1IG4OzH46uzI4F9Pw44M+9qyCHcpKTeDTFCwojN9etVJPv3BqX3MJ769zhXaPqmUF4jgjsZtfyUW0N4l0MViof/wgqkwK+TTb1YKm8XIZnmEnxEncw/CiaUNwvQNUMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZGJid9jF; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723617287; x=1755153287;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WpXPcx35BuQ+SlkHkwnyVw+tiP2AD4vHyInROmfia0o=;
  b=ZGJid9jFd10XRSqMObpMLmoBW1BcsmZAArxe3mWpiQIKztvEWFmcYFoL
   P0/4KuCyT/ycoH6WdPNxmwVeCjBBA8d2JFRJZlMc7D/8kylUkTsuy5UgZ
   jKLPu73CyBC7I6K1eTSUQrkPD/hzGPyQyXuOh2pA+CDv4FPas7Uu8RKUD
   RzBRJpxJpxMNXLnSvMkxU6D3dMwAd3D2lbgpaMTi3jsbYVe5Wm4PZBwSk
   SpQ6OIPDVPrZh8DAhTm8LkrgBoykdsDqWLh2NdiV/0+y3jJCHotuGdWT1
   plNYBiUSyjW5b6DUuohUX4gHfNmE1mn5nzOfSB2Eh7uXj84TF3D1IHW5F
   g==;
X-CSE-ConnectionGUID: ASFJe7hUSsCqnGicqLN6MQ==
X-CSE-MsgGUID: 1/5J290HQ9enCLHIswYgIQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="21629287"
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="21629287"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 23:34:47 -0700
X-CSE-ConnectionGUID: E9xsmG3HTBW3GyAOcfksOg==
X-CSE-MsgGUID: ppiHWKYIS7anmexB+LpniA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="89719847"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Aug 2024 23:34:38 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 13 Aug 2024 23:34:37 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 13 Aug 2024 23:34:37 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 13 Aug 2024 23:34:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ouU2VMRoVCnjLshCpzILL4v51MSifkZI4xHaVTAqXbnnlYgn6QGPSDjLsn4IaD1KmIjVJAdel5KRNJstYAjYaObTPLRSIh61aesecpQJfuaaB3RlY6P8M59Bejy2Msv8hOLdRzxKcOd322dVqLmZ/bEpb7z/IFbUuqJYv4N8wfY5tL/Zbp4NhYqhD0e0qHnsOeHMS7ezH858PWh19cgOKkDtRlU4Wcs4Tb2+RUf902XHmz2svYq3Ie8OrpjGZ+E5QTBT1pOZm9Az7DMrRe9Q0VP9tqqt1A6Dd4xqnVw//jVXlb3I3/Cdg0kDz9P7H5dhGAa75LHl2zGOicKhHLhGTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s3JPoiHsVhagpi1zD8HBD+x5KvUfkagmYrAAgv+RXOo=;
 b=OI2eUkXuhI15r4r+EL0+Gu8Cw3YGyPTHcyxXWfOYmjNYTjg9pLS/JvARRXn3ScbNMC9x4H45Xa3s4w9N7Zg9+pKQhb7Fdjbj2dtkLFHUQdhAFrxG91eWtC6F/3C8ZUkFZt9aLYHF8Kv7NE4Np/59PGwLRLJRALqRoE4SK3I2vOEG1jdFWbSj0eH3uX+gbdphnYo6Gex1YBwouKho5Tg5tCmdU8/gZ8OH4gEZP1P7YboUqbD9MqJV6wNc+Enian0NbuKXwFKqQOnKpqhMXvMFh6Ow2jayrzyxRbUS/IEUhSy0bKh/uSlt2LDdn3RISStBjeYEOJ1yV+N+dHDdoNp0zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW4PR11MB6840.namprd11.prod.outlook.com (2603:10b6:303:222::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.24; Wed, 14 Aug
 2024 06:34:31 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7828.030; Wed, 14 Aug 2024
 06:34:31 +0000
Message-ID: <0ae87b83-c936-47d2-b981-ef1e8c87f7fa@intel.com>
Date: Wed, 14 Aug 2024 14:38:44 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
To: Jason Gunthorpe <jgg@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>
CC: Alex Williamson <alex.williamson@redhat.com>, "joro@8bytes.org"
	<joro@8bytes.org>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
	<clg@redhat.com>
References: <20240426141117.GY941030@nvidia.com>
 <20240426141354.1f003b5f.alex.williamson@redhat.com>
 <20240429174442.GJ941030@nvidia.com>
 <BN9PR11MB5276C4EF3CFB6075C7FC60AC8CAA2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240730113517.27b06160.alex.williamson@redhat.com>
 <BN9PR11MB5276D184783C687B0B1B6FE68CB12@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240731110436.7a569ce0.alex.williamson@redhat.com>
 <BN9PR11MB5276BEBDDD6720C2FEFD4B718CB22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240802122528.329814a7.alex.williamson@redhat.com>
 <BN9PR11MB5276318969A212AD0649C7BE8CBE2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240806142047.GN478300@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240806142047.GN478300@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0017.apcprd02.prod.outlook.com
 (2603:1096:3:17::29) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|MW4PR11MB6840:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e0d31e3-7984-41e2-779f-08dcbc2b2760
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dUxFK1JDME4ySVl5R1dtS2NBSmJSSXlTQUVQRG5TaFZ2blplTUVzbHhjb2xQ?=
 =?utf-8?B?REJUYW9JMm4rZkIybDVvTWJNY0JLZExPU2grcWJ6L1I2RVNYNFRPWEExYXBl?=
 =?utf-8?B?K3RJTktBMjlMOHZtR1V4L0dZQVc1bjhFTS9SK1RkS2VFV21BWXRpQ09aT1VW?=
 =?utf-8?B?RDkwR2dmNER5dnJ2QmpkcWowbncvakdFWmFPd3hFR0NmaXFNQ1IyRyswQVVW?=
 =?utf-8?B?TFI1N3h4dE9ZVDAxSjVKY2hmM3EyTzFzNlBxSGp1NWYzbE9jc0VSU2pIY1FF?=
 =?utf-8?B?UUs1cHJHSFk2N2QzZ2N0cU1kbHYvUFBaZWVMTTZ1bHl6MVJEb01BK1ZZS2VJ?=
 =?utf-8?B?UDNPNjA2UVg2OHROeDhSNnNqT0NkZWZVaEQxQ2lCdEtzOExLTHFlUnZXa0Fw?=
 =?utf-8?B?OWlHdW5UM3dNWGlKc0dNSGpReFIyVUtab2UvbGhheFZkemdiQVloS0crbHpJ?=
 =?utf-8?B?L0hkeFlwZUM3b3NXU1lURDVDVThrS2RyMHIrblduZTRiNUFNU1Q5TWRDWEtT?=
 =?utf-8?B?SFdvcGM3R01vTk9nZitWZ3RwRHZ2MThzYzBJaTMxZWxLK3lpdzVHUy9vTkVW?=
 =?utf-8?B?NWplc2FNRGpEL2ZTUWFuMUZwaEdFZVVDcG9oTnpzUGRsNjVncWFKd01GVjFM?=
 =?utf-8?B?SDFtNlpJQ3BRbG5YQXBQeHhvZnZPTTByeGNWRi96Z2Y2MUxPckRsbXFvNzlp?=
 =?utf-8?B?SmF2VzU1dDFiRHZ3SU0wOUxvRXROdE9aWnJqR2szV2FOYUtmUlcwaHZsc2Ro?=
 =?utf-8?B?dnYrTEluRVBDNG1rV3grckJrSGNRNktXUDJ5andLUTFLeUlrUkFCcDU2ZXNJ?=
 =?utf-8?B?NHZMZG5TWktCakcyc2sxT2pWYUZVeEowZzhHWVN4aHBlSkNCQ3dqNU11M0ln?=
 =?utf-8?B?MmhFa1ZTMGRZbXQ0alVFZERGQ29XZ1JoQ21ZNlBqaUc2TGpyeGhESlU5K2xo?=
 =?utf-8?B?OXJsY1VZV29FWHBwU3R2WnVRejNma0hMRmpzTjZvQ0tGSmJZd2thcEh0aU96?=
 =?utf-8?B?WkJ3V0hJdFVIK0FuVDkyUXprYUxVNzltZEcrL1VjZ3VsbXdaSFVmY2QzUU04?=
 =?utf-8?B?azlmOWVsaTJXdWpWM29UcVRLWjdmTGo5THlZNUJ0aDBRSjBPMnZKa0JWT2tS?=
 =?utf-8?B?ZFJWamo0Y2xXejBQcUhnQ3F3WnJYTHJvdUdCaWp3UnhzZkJBT2puYTFpbTFD?=
 =?utf-8?B?K1g0TTQ3SFJBL3pQSEhjbXdyRkMxd0c1M3FuMDZoS2xJZ0tDbmhyNmRYc1hh?=
 =?utf-8?B?N2k3anduNjdhRkhaMTBTRXA4Z0dEN2NwaHFBbE1mQTJNTWQ1S3lEcUI0WWZo?=
 =?utf-8?B?eWhiRHByS0JsR2NjUStmQ0tsV2VRTUhQa2pScEZMZXRBUE1jS2Qvc1RTbXhD?=
 =?utf-8?B?Y1RONGM1MlVETHFUTkUrTndXOEV3akxralRLRWtOOGhsR0F0RVlna29EWCtj?=
 =?utf-8?B?dUpBMHZpVHF2ZDVmR1F5Z2ZEajdwcnVJMHNZR1Nsc2hlY0V0eC9FbDR4TG02?=
 =?utf-8?B?dnFNKytodTVLWTF1UGZqN3NOeUxTYkJuL1REaFA3ZlhleEtqVGI2TWlvRU91?=
 =?utf-8?B?VDZJdkZOeEo1MFZYMGtqRDY4Si93RmxkT2R2aTUwc2R2ZlU3WjVzUHhqcW01?=
 =?utf-8?B?M3Q5d0ZHcldnc1gzQWlLTzFMY1M1NndvT0lwam1DWnJkUk9hdXZSZStBT2lo?=
 =?utf-8?B?aTIyajFVa2VjMDE3NXQyaVJDQW8yRVh1WW9RT1Q0S1VFRkM3a1VTbXZSNU5H?=
 =?utf-8?B?QnZYdEphWi9DRzJEMW9qSUJaWFU1d1pEV1FEUTRDSzluSGZGY2lNd3U0SGIz?=
 =?utf-8?B?UEFrN0hJRllqTEc5U3ZSdz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UW91NWhhM0RFbzNGVW8xVzFGMFQvc0xnY1ZFb1doMFUwZlJuTEVFWDlWc2JE?=
 =?utf-8?B?RWtxNWI1SW55VlUrTnlrNlNITXRBd2Vydyt1b1ZFb3Z4KzVxUkVxMlBxZTNi?=
 =?utf-8?B?MXc5ME5ZWDV4VG9Pelhzc09qcnN1OXJlYkpMdThBM3BQWXlFME1rd0NSRHYx?=
 =?utf-8?B?VGQ1Zk4xdE5rTThJL0hQb2pyV1gyK2RrUHUyVGluSEwya3NsaGtQOHNWRGRj?=
 =?utf-8?B?cG5QSThQeW9CQ1ZWc1BHTmZyN2MzVWtEQ1h6QksyN0pTN0NTZWtzZUhzaUV5?=
 =?utf-8?B?aXR0NnJaTm1zVmJmUU5QZHJrY3oreCt6czZuN2FKMUNvVVorYVIwNG8xeWRy?=
 =?utf-8?B?dmk5SmYrellPRmlwMTg0bWxWT2crY1hjK1BJWVRqSVdZMDhYaVZsRTA2cENr?=
 =?utf-8?B?M1B2Y1JwSWhMeGR3ZEE1NVNFOTJCRXE2aHN6Y2lGRXRpbnZiZnpOY2hqbTJZ?=
 =?utf-8?B?WU53UjBFKzlRb0tDVDdwSm1hZWdNeTQ0UDgwL0t6b1VJbVQwM1FDSXJlTUJy?=
 =?utf-8?B?emIxN3hEcFZQSUxHSFZ4eDd2SlJhc0szc3hvRkRJK1FJc0xKbENOdkZ0eDlr?=
 =?utf-8?B?OUEzY1JJRHJHd0JiMC9PUC9IbUdUb0pxb3hUZ1gvR1QyWXU5dGx4TTJORVd5?=
 =?utf-8?B?dnNlMFR2UkYrT0QvY0xPdmhZKzF2WVNHTFNLbksxN04wcExENUhoNzBhWWxM?=
 =?utf-8?B?RlhGL2JMZjloMTR1TWdIaUxxRlIxMnBjY2ltVVU0bzZGalZqRHlmc2ZGTS9j?=
 =?utf-8?B?dkdOSVZ6WU5MVHFWUnFMQW4rb1N5Snkrczg1SERuQlpzZWVDd29jdU5kRTJJ?=
 =?utf-8?B?RzNrTEdMc1JsMjNnTHM4UGNUVER3UzFrK2laZTZlZzBnNDhjYjVBS3NDT0Fh?=
 =?utf-8?B?cmR5Q1J5ZVltRlp6UmNuSDNHWmxpb1R2Z25IZU81ZkgrTnhDeDhJNWI4WjVN?=
 =?utf-8?B?bEFPdDdjUU00RkpaTUUyOEY1QlhHajlDc1FxNUw5a0hTTWwxY2NDRDI0UWtq?=
 =?utf-8?B?UUtabXVaL2tUdjFvMWxjOWVwY3VPemlxZ2tIYlhpZzVNTnJXK2JCMFFEWlJ6?=
 =?utf-8?B?N1M3Z1JrMHV5QWhmOWxaTHVXa2Z5WkViNUlPbThkOHpKRVBQdlNLcWlLQ3dn?=
 =?utf-8?B?a0dIb1pmVllMNktJODRxMVRYTWtIZCtsNm5wUTc4OS9QTmJ0QVBFalA1TzhH?=
 =?utf-8?B?SDlLaGxhQ3h1YU15TlRjeFdqZUhLdUNxVHhuOW9rZkpiTFlveElzd0hKWFVK?=
 =?utf-8?B?UmgrMW0xaW1rWWk1cE8xVFVZUml6OTRzUmdENGp0STFnU0YvL1ppZzQ0SDV4?=
 =?utf-8?B?Z0Z3UWk3TXhndy9LRHhEdEhFUW5iRnpFVVBQdGRZT2lHdGQrSGxHOWRQQmw2?=
 =?utf-8?B?djhITDQ5VnI3ZU5NL3o3cE9Lck0yaWlqTkppaHgrcktxb2lyUkE5NU5nNDVR?=
 =?utf-8?B?V2dGem9QeEZKck1ud1RyUkpINWdsWjAxUk1EeUsrMXZ4eDJCMjlOelRBaVl0?=
 =?utf-8?B?SGRYcEo1ZHZkRWhoWXh1QndFRElWSmVNT1BwNlFGZTZzQTFxNkdpd3VSNjF4?=
 =?utf-8?B?MnhOL1lTekpRd0FZNmZMOFhQSEhlTXVrU0FHeUUxNXRKcWhkT0lvR2phQ1o5?=
 =?utf-8?B?OVFyZ2M4b2hnV2ViV3JqYXpFdDRtTjZieXpldUhiSlFsK3pZTnlYQ2dDdlZB?=
 =?utf-8?B?a0thVHVsWFdPT3NYd3JMUkZNMXRKWmQxdzBYTjgxMDYyQVJBOE9DcVNBMWZq?=
 =?utf-8?B?UElKVXlCU0gxSzJXZzF6NmVYTDhTeTNWeEgwQVZabU9sRWd5ZUdtdlhxdEZ0?=
 =?utf-8?B?enZIWkhhRnAzdHkvbTZMaEZYTEwrQzAvcXN4SllDcnRoV1RadStiNGZka3M5?=
 =?utf-8?B?bm96bmJWeXlqblp2WHBPMStMRGx2SlFpRVFEZTJIcy8wVzRlRERaT3BGUjEr?=
 =?utf-8?B?ZExka3gxcmdFWGFiU2J3dlU4SXk1WUdNQ3FLR3dTTmxWNXBPK2F6blp0MlU4?=
 =?utf-8?B?Rmp3MjlQbXdHTXcxMGpOVVllcEpWdjMyNnlSZjJhYzE1V2Q2MmR5cnF3K0Rx?=
 =?utf-8?B?RWYwQUlSSXJ2WkZKT0F6b3NqZXRFWWZCYVVXNzdXdG8zODVZL0F4aTlWVzIr?=
 =?utf-8?Q?GSQ4o/7s7jj3MX2HDFXUOKMlC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e0d31e3-7984-41e2-779f-08dcbc2b2760
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 06:34:31.3269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5fRtT6SPO7GEhbejUuzDfnL2M61YV5n1O1WzwBr3PXL1gPtME+z1ygbyMJ3VaMIORLLVm0A+Zbuzu/vVu02dnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6840
X-OriginatorOrg: intel.com

On 2024/8/6 22:20, Jason Gunthorpe wrote:
> On Mon, Aug 05, 2024 at 05:35:17AM +0000, Tian, Kevin wrote:
> 
>> Okay. With that I edited my earlier reply a bit by removing the note
>> of cmdline option, adding DVSEC possibility, and making it clear that
>> the PASID option is in vIOMMU:
>>
>> "
>> Overall this sounds a feasible path to move forward - starting with
>> the VMM to find the gap automatically if PASID is opted in vIOMMU.
>> Devices with hidden registers may fail. Devices with volatile
>> config space due to FW upgrade or cross vendors may fail to migrate.
>> Then evolving it to the file-based scheme, and there is time to discuss
>> any intermediate improvement (fixed quirks, DVSEC, etc.) in between.
>> "
>>
>> Jason, your thoughts?
> 
> This thread is big and I've read it quickly, but I could support the
> above summary.
> 

thanks for the ideas. I think we still need a uapi to report if the device
supports PASID or not. Do we have agreement on where should this uapi be
defined? vfio or iommufd.

Besides, I've a question on how the userspace know the hidden registers
when trying to find a gap for the vPASID cap. It should only know the
standard pci caps.

-- 
Regards,
Yi Liu

