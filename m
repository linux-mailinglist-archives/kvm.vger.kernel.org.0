Return-Path: <kvm+bounces-15906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C51B8B203A
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 13:30:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BD231C23361
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 11:30:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5703E12AAC7;
	Thu, 25 Apr 2024 11:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U4HJxHV1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0691883CCD;
	Thu, 25 Apr 2024 11:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714044595; cv=fail; b=gL3z5gNltvbGsrnUL6uaGvGwEnLIffmdjgFu3+Y5O6O1yWYnrPeCtU7BxcMUnANXmnoLhsi/4gxc7ba2W33XjtuhOEhF2TpuWNSlSVHo8Ddpl+Bm9sfsvVukM6XKbRzecdheyba3fl4MsNUySGNXMEUIQscceHKxHgt+cF+zT/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714044595; c=relaxed/simple;
	bh=PtD+mSQyw/7RROUW6qbeInrk77tMVeq0k3zqZ4fkD84=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sN6Mr1fpiZnnxj30AEz/copMr8e8RHjd5pYuzdTXCbetTnQTcHrzdlX9FDyE3kPO/gwHgTpQnU/B2WNufCYKYsQn/eVBzjKJQUEv69KunaIGkh8sOdpfr1gKQjmRY9B/M2ZISvugPUpFNRCzdh7aTxbegua9nrX9SeIcaqMp1sI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U4HJxHV1; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714044594; x=1745580594;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PtD+mSQyw/7RROUW6qbeInrk77tMVeq0k3zqZ4fkD84=;
  b=U4HJxHV1n8/xN8M8jgAtrRFzUv6G0oGku3zAxY0+aPIcLXCSDzxP3PQa
   ah7lHQyUqCiCJMX9URoGTLqsU4QZjOXZjrYUfkJRucW6i5ncDk5yjCTll
   dNvMylQ9XdWc0I8WIjEE3FkBQmgVDiSht4zq4jnIX4NwYCOCgXngave2O
   pOalN8ODcIXt3lcVHvzmhcwSTrtCazCJnY6EStHbN/9tShfjFXCS+oIf/
   e3geArWVSjJFAdw5rKtRA2e7szITujXKZLeEp7ZD2LMnEq+DNp4+N92FE
   e8TA8CrGdyb6/m65/VB1rR0DqFIuxDpuHtQptISIXGuR9vVMlPRJ+I/si
   w==;
X-CSE-ConnectionGUID: +p9BsRQuQYWBnnIYK4OFQA==
X-CSE-MsgGUID: WhEl9NCQTr6zuDIVVBs69A==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="20873936"
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="20873936"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 04:29:54 -0700
X-CSE-ConnectionGUID: myniDvWtQzGhn5n8E/jEgw==
X-CSE-MsgGUID: yibS0iuvQCed7AtZ+2Vzhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="25106024"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Apr 2024 04:29:53 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 04:29:52 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Apr 2024 04:29:52 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Apr 2024 04:29:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q6+pFcD/wWgfKLWKaYW4uZcrW+9eQogL07oa4WPZP2f3lsX//eUA4HSHTYl9LIu9P7T9zd/mKu13kOJiqWFyPTu0JSfFu39ZDNpKx/VxdWHzjWCT9x6Otrcc0fTN4ZmibMNs+d2w20zLnrfHzB44Xtzr95bkSiNLbZ5VLz83HnCks1RVYOGc/s7ptLZdbHH+tDeBQDXN+KT9r/rSXK6C1EtJn5FXl+4hxBdTQgWhFlQ8ijnqbjrP+7/6MK5tXkDF2lHnQ52PXxZ0cM0bXDJrC865D51Nif8Rz95LrqrpeHOBvbTcZmDONkF1RYDCarBBCgJoZDSIGf/XMwYbmOOb7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PtD+mSQyw/7RROUW6qbeInrk77tMVeq0k3zqZ4fkD84=;
 b=KHcOq/y6HrcVtV+LAepcjxdpb7Vc8O4sQC+mfKvbb9WH8O/bsqGBKTpDjfhNWOlcxMV7Ynq1teGxtLH7/Sx3J1/80uafKG3yNTOUoKaL1ou5lH47afkLvnglT6RdlVFDVlDzjpj8pNYDZ6E5DogYwud1JU4lL5/PC3ke9cwSOnkAGGkPKqi6o/c6llmQYQE5q95CjpYcDAPCyJDh30zfIWyj1nQUj0SOCYhbyIZHRj0JxMjSbN+UawN0/o4vUnOV3A/jJzV6DJEnnQ9cj7g8gofJzwlEkSM74G7/pFGVUNbTxvwl5UMI6Qo8n9Uryz1iSSHq5Is5PpYi+pBYCti8Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 CO1PR11MB5105.namprd11.prod.outlook.com (2603:10b6:303:9f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7519.22; Thu, 25 Apr 2024 11:29:50 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::55de:b95:2c83:7e6c]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::55de:b95:2c83:7e6c%7]) with mapi id 15.20.7519.021; Thu, 25 Apr 2024
 11:29:50 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/4] KVM: x86: Add a struct to consolidate host values,
 e.g. EFER, XCR0, etc...
Thread-Topic: [PATCH 1/4] KVM: x86: Add a struct to consolidate host values,
 e.g. EFER, XCR0, etc...
Thread-Index: AQHalcvRIagHuf/K/kmJgZMA6+igorF4N0TQ
Date: Thu, 25 Apr 2024 11:29:50 +0000
Message-ID: <DS0PR11MB6373B95FF222DD6939CFEFC6DC172@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20240423221521.2923759-1-seanjc@google.com>
 <20240423221521.2923759-2-seanjc@google.com>
In-Reply-To: <20240423221521.2923759-2-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|CO1PR11MB5105:EE_
x-ms-office365-filtering-correlation-id: fa82159a-5950-44ea-48de-08dc651b055f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?WHdHUFNoNGpNemtMQm9TUkgvOFpyZDlRQlNMTHFoZVI5OTBNamkrbEdadStu?=
 =?utf-8?B?bTZvYkFUSmZJcURVbU0xUWduODQ2aUNxYnI1VDc1bFY0QUFGWFVoQ1V3QXhL?=
 =?utf-8?B?cHk2ME1PNC9TUVJud3B4N0hhVllMckFJd04zckNFVU9kVlM0cUxnRy9Id2dF?=
 =?utf-8?B?cXN1MmZIQUhwNThMa3lTY09HZmV4WFJNYVhZanY2QnRnSmhQaDRoRFNDYVkx?=
 =?utf-8?B?T04xN1kyS2dwM1piVzhZeVRiVGE4NGlIaTRHVXlhdXFWaTFnajQ4dUFzSllF?=
 =?utf-8?B?YWI5c3RSdFlvdmJIM0lQUFYwQklmSERrZlpkRjM1R3EzUCtkQzRHSGUzQ0ZN?=
 =?utf-8?B?R2g1K1p6ODBNOTNONGNFZGZ3Z3lkZE9yaDMzS2czWkpWem1HWGlpWlcweWpm?=
 =?utf-8?B?UDcrYjRIRXJ6TXZnZmZmSVJRNzdBZCtFdkZYVGRKdzUwc25QK0Zac0RSQi9M?=
 =?utf-8?B?U1NhanNsWlVVQjdRWGdvWWZzNERCM3JPVE0ycG9DNDcycDNYMis2VWZRZ2tK?=
 =?utf-8?B?Qzd1UEw0V3FwU3d6Q3kyRVMrZ0k2SUVrTUZKbUYyS0NaV2x3elZNVTZMNzQr?=
 =?utf-8?B?MDlKM0VVM2JYaUNHbEZ6cU52TE4yZXg1U0ZRa3V5aVZqaWJMMnIvR0o5Y296?=
 =?utf-8?B?VHNvbnI5Q2lkNVZFQUREN1ZTK2thYVRnYTNmRnRveHdYRkxTc2hxQkVMWHhv?=
 =?utf-8?B?cXBGNDBCTWREL2N1N25uTWZHZHQ1c3JmVjRmWS80d1dIRVZMQW94eVdYZ1A1?=
 =?utf-8?B?clY0TlJjUFF0YXM3cUEyMTlacGpRYTJIK3pjcGNkSkV2Z1FhcUMxb3BWamNi?=
 =?utf-8?B?MFUyNTRrMGRjYmpXeEgwTzU3ekRCaWg3a0VXd1pGTHpZeG4zbnlLT2RaTmVI?=
 =?utf-8?B?akgzMGJTbFpIbCtxbjRLY2ZWQndzN2JSNWpLLzJ1dmcrakR4ZG1YczFodWtX?=
 =?utf-8?B?aldIQ3pZdmdxWVA2RU9tT0NWam4vekZUQ3BwNTVqODZPQVUyMXdEek5hQ0JC?=
 =?utf-8?B?Y0VIS082WlRmMENpellNN3VGOWhCNU1wUThtVFJuQTlBR1FvWVVWN2tVeUZD?=
 =?utf-8?B?UlVKbUtqS0dKcTRHOUh6N01vb0VlMVJRYStMb1hDb3lNOVZidUZudHRwNkQy?=
 =?utf-8?B?eXRPK1BGeUJ1NzF5ODBQUkF6NmxTbHJST1hIUkIyRG1zZDF4SytSTlplSzZy?=
 =?utf-8?B?eTljMk5PRzM5QklqcG1VZG5jNlZBRERzbjRDMkFML1RrVC9veHpmNjQ5bm8w?=
 =?utf-8?B?aWU5Y2RpTHVRQ2dvVDdJZnpiNnNGNk1LWi8zSTJWdFZoL2s5dEllREtnNmJx?=
 =?utf-8?B?K0JkenJyM0ZFUmtXMUlqRk9qMkZlQk1ZU28vWUF6bHR4MXpmY2VwcmYraEMz?=
 =?utf-8?B?VDd4RDRvakwyL0hZcExOaXBZbEhyZVg2cXp0N2srMGNxYVRocVJrVjE3Z3JE?=
 =?utf-8?B?a0grQzNoU3k1RlNsaUI2RUdWU0hsdldrTll5Rkc5Rk9GeStUaDEwNmU2YkVX?=
 =?utf-8?B?T2hQOUdjdFVXKzJYbEo0RzRSM2duYnJ6RG92Ly9KL2xPRmZBb01QRVRucDRa?=
 =?utf-8?B?UkRHdmNzZVdQZmt4WUJ6WVlLcVI3eE9KMUlJTzU3Y1dvcU81SEh3ZDVJdHFl?=
 =?utf-8?B?R3d3MVl3L252eHVvWmR0L0Qrd2VwcTlCUnFHODJpK2tyeUxPODNwTW5MdDF4?=
 =?utf-8?B?d3BKN0pneWJOYXdYZDdnaC9wZ2Q3bEp6Q1k4Y3FrWkRGRUJwVUEwWnkzZDE2?=
 =?utf-8?B?YmJNM0hKU0RGM1A0ZGVLR3dUL2kyYVRycW02UHFCWXNTdG80Y2Jac0NSQW5x?=
 =?utf-8?B?Nk5nSFJHMzdWK2taZlBFQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RS9OVXRkRjkvcUFLYi9XZ0VvK1cyNUVPb1hKNk1kcXJsYkRoQ1FKRUdVZFFN?=
 =?utf-8?B?UHQ5aWVnbTJIYmNpUFZkQ3ZldEdVMGJ1RkpsbEFoeHJoY3lUb3JoY01zeUUz?=
 =?utf-8?B?ZTdnYk9TK0wyTFZkK0tqaVFBOFJlekpZb3EybEduUW9XbVZuT2VTZnpoYyt5?=
 =?utf-8?B?NzNSUzBENk8rU2RGa0tKTkNoRXR3amdNUWlMWWpCbTRXbDRJU3lNUjlpK3RT?=
 =?utf-8?B?dzFvelFWTVNtK0p2dVdpbDdpR253ZUptY01lVG83aEF1N2QzZkV0MmxyZjU3?=
 =?utf-8?B?ZWw3b05xcEZ3ODhOY0cyZkZLdysxckplVzI0QmVUSlFzYkdxL0ZGaExEakZz?=
 =?utf-8?B?dnZ6U3pjYkc0c3JLcVVTSzI0UVV6eS9HWG95SjAyZkRyTXJnTm13Z3JKTWha?=
 =?utf-8?B?ZmVmMk9qMGRHdkpPTEdJNkNxRG9jejcveko0d2hKWnNQSkFWSE9XNG95QVVP?=
 =?utf-8?B?U0lvOWZvVW9OY1VmSDZPMlRLT1FpSWl6NDVYRlpaODdpcjc0MEg0WStnSFcv?=
 =?utf-8?B?cHVCVHE2OGM1QS9CUExiWkpSNTY3WnJUNkxrZ2hLdE5jaG54WU8vUndkVlQ0?=
 =?utf-8?B?VlZsNVhYZy9PYzBPTGVaTDNEZEUyN0wyT2dJTlZydTVORXIrWk0wSXRKTlh4?=
 =?utf-8?B?TkJFT251Tk00OC9vaXI0a256Q3lDOXY2c1FzUUFQcWxMTkFvQnROMlRFN3hz?=
 =?utf-8?B?REIyVkVlamdRZ2VqbnA2ZS9UbTNxc2M3NndpSEltK0hva0g5dFdIRkJlczlx?=
 =?utf-8?B?SjhjOUNnVnpZQ2ttSmdPVUxoN1NFSVNqd3RZZXgxQk5valZNamM0bGVFOFhm?=
 =?utf-8?B?QmZUZkNBZFZpeW1HS1dpanJQQmc1dWNhajk2NGhMNUsrVXl3TGtFekd5YzVw?=
 =?utf-8?B?bkdFUHZnMWF1Y3h3Q1BEYk5nWEZSWUpvSHJMUzNZWm9hdnozVFJSTTdYQVg0?=
 =?utf-8?B?M3JWN0k4dVdpdE4yR0ZOUDVrN1hDVXlHQWZXUGhwVUpyUE94M29xdmh0V1FT?=
 =?utf-8?B?ZHpIUW9hdG40TGJEd0IvTXovWkJ1aXJnaGtOaHBMZ0tnK2Y1L0tXYk5YZmZM?=
 =?utf-8?B?akowN0hLUDlzMHlMUEI2UkNiU1VHYXlORnZrd0hJenJWSzdrMXBFc2VZVEpt?=
 =?utf-8?B?ZkZRNlFteFNKZTNhVWZ1blJIbmtLZ2xvOU9zcE1jRjAwVHphUTNKKzVudGd2?=
 =?utf-8?B?RWV0clMyQ1ZsZGhwWHU5UVNyYlFJMlpwQ3QzOWc5T2E2Q1l6cnlnaVRSVzRq?=
 =?utf-8?B?TVdTTzB5ZVdJOGFiVHRybkVNRmNpVi9CbE9kOE1kRWtLdDY2VzU3aFB1OVVI?=
 =?utf-8?B?a1lxRndrZTRJemREWWRmTVdXYU1ZZmtmRGRwYkF6RWs3UFNkenNxcU1RcGpk?=
 =?utf-8?B?akJkY0podDE4RmdGYUZUN2xEZElncWNTdXBPeVM2NjFVMW9vd0YrNnZsUThC?=
 =?utf-8?B?OEY1K0FnZldONmNFend5MFFTNTUwSmx6QWQ0T3Vva3V3dWJROXlSaXZ0NU9w?=
 =?utf-8?B?V210Si9nNmZZUkIxYjhReDZLZ2d3SUV5cmJ5Tk9mTTZPbllnUkNTc1c4aVdK?=
 =?utf-8?B?MzVPWWlFRVVsbzRHNm5BVkY0Zi8vdTQ4WEpXWUk4OVN6VGFHOEhzR2VQN0dW?=
 =?utf-8?B?Q29nbVMvWjQvQXAxUDNyaHhHRDFmaG0xUmJJaitiZ1FkTGh3WGdCWEJYYUlQ?=
 =?utf-8?B?ZlUySkErbndWQ0hScGFaZGVBTmhZK3pUMVFYdlRrZWxWeWdyV1k0YVJ1SWwy?=
 =?utf-8?B?dU9LSDB2WjdDQ21RaVd3bUpPZHFhT2xoVkt6K0g1UU5rekhIYjllT0V1ZnFs?=
 =?utf-8?B?QkJnRHJuMFJzMjNlcnVmQWIzdHN1TjcvWEV5RTA1cW5SZ2VOd2pxeSs1SkJD?=
 =?utf-8?B?SWwwZGJoWGFVUlpkS3JiYURuWTlrZHFQb05xKzV6Vks0em0vMHFwdDZCNjlX?=
 =?utf-8?B?cnM1VUo4Z3ljS1E3ajVIWCtUcldYNEhHdzl1dXh0SlBYcEgwamU1TXFvNDE0?=
 =?utf-8?B?ell2R1NzUkhVYmtVeXY3YllSaGZBNjhCSEkyYlpJRFprSURTdjJ3TDMrUFBk?=
 =?utf-8?B?RkQ0RzRKVWgyWXB5RGRERC9hTkdyc0RhdEQyM3JFWThKaWFScmE0YVdEcE9t?=
 =?utf-8?Q?Ux/ID+FXvIF9z8PwDKuLQeY1e?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa82159a-5950-44ea-48de-08dc651b055f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2024 11:29:50.8004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fxya86iWkU+oUpsO9rJcXyYhK5OsKDBQxkxKBI80cb+4pVY64+MhvQrbPCCzY1GnGjmy3Wlh3WFvun2il+SXvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5105
X-OriginatorOrg: intel.com

T24gV2VkbmVzZGF5LCBBcHJpbCAyNCwgMjAyNCA2OjE1IEFNLCBTZWFuIENocmlzdG9waGVyc29u
IHdyb3RlOg0KPiBAQCAtNDAzLDcgKzQwMyw3IEBAIHN0YXRpYyB2b2lkIHZteF91cGRhdGVfZmJf
Y2xlYXJfZGlzKHN0cnVjdCBrdm1fdmNwdQ0KPiAqdmNwdSwgc3RydWN0IHZjcHVfdm14ICp2bXgp
DQo+ICAJICogYW5kIFZNLUV4aXQuDQo+ICAJICovDQo+ICAJdm14LT5kaXNhYmxlX2ZiX2NsZWFy
DQo+ID0gIWNwdV9mZWF0dXJlX2VuYWJsZWQoWDg2X0ZFQVRVUkVfQ0xFQVJfQ1BVX0JVRikgJiYN
Cj4gLQkJCQkoaG9zdF9hcmNoX2NhcGFiaWxpdGllcyAmDQo+IEFSQ0hfQ0FQX0ZCX0NMRUFSX0NU
UkwpICYmDQo+ICsJCQkJKGt2bV9ob3N0LmFyY2hfY2FwYWJpbGl0aWVzICYNCj4gQVJDSF9DQVBf
RkJfQ0xFQVJfQ1RSTCkgJiYNCg0KVGhlIGxpbmUgb2YgY29kZSBhcHBlYXJzIHRvIGJlIGxlbmd0
aHkuIEl0IHdvdWxkIGJlIHByZWZlcmFibGUgdG8gbGltaXQgaXQgdG8gdW5kZXINCjgwIGNvbHVt
bnMgcGVyIGxpbmUuDQoNCj4gIAkJCQkhYm9vdF9jcHVfaGFzX2J1ZyhYODZfQlVHX01EUykgJiYN
Cj4gIAkJCQkhYm9vdF9jcHVfaGFzX2J1ZyhYODZfQlVHX1RBQSk7DQo+IA0KPiBAQCAtMTExNiwx
MiArMTExNiwxMiBAQCBzdGF0aWMgYm9vbCB1cGRhdGVfdHJhbnNpdGlvbl9lZmVyKHN0cnVjdA0K
PiB2Y3B1X3ZteCAqdm14KQ0KPiAgCSAqIGF0b21pY2FsbHksIHNpbmNlIGl0J3MgZmFzdGVyIHRo
YW4gc3dpdGNoaW5nIGl0IG1hbnVhbGx5Lg0KPiAgCSAqLw0KPiAgCWlmIChjcHVfaGFzX2xvYWRf
aWEzMl9lZmVyKCkgfHwNCj4gLQkgICAgKGVuYWJsZV9lcHQgJiYgKCh2bXgtPnZjcHUuYXJjaC5l
ZmVyIF4gaG9zdF9lZmVyKSAmIEVGRVJfTlgpKSkgew0KPiArCSAgICAoZW5hYmxlX2VwdCAmJiAo
KHZteC0+dmNwdS5hcmNoLmVmZXIgXiBrdm1faG9zdC5lZmVyKSAmIEVGRVJfTlgpKSkNCj4gK3sN
Cj4gIAkJaWYgKCEoZ3Vlc3RfZWZlciAmIEVGRVJfTE1BKSkNCj4gIAkJCWd1ZXN0X2VmZXIgJj0g
fkVGRVJfTE1FOw0KPiAtCQlpZiAoZ3Vlc3RfZWZlciAhPSBob3N0X2VmZXIpDQo+ICsJCWlmIChn
dWVzdF9lZmVyICE9IGt2bV9ob3N0LmVmZXIpDQo+ICAJCQlhZGRfYXRvbWljX3N3aXRjaF9tc3Io
dm14LCBNU1JfRUZFUiwNCj4gLQkJCQkJICAgICAgZ3Vlc3RfZWZlciwgaG9zdF9lZmVyLCBmYWxz
ZSk7DQo+ICsJCQkJCSAgICAgIGd1ZXN0X2VmZXIsIGt2bV9ob3N0LmVmZXIsIGZhbHNlKTsNCj4g
IAkJZWxzZQ0KPiAgCQkJY2xlYXJfYXRvbWljX3N3aXRjaF9tc3Iodm14LCBNU1JfRUZFUik7DQo+
ICAJCXJldHVybiBmYWxzZTsNCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS94ODYuaCBiL2Fy
Y2gveDg2L2t2bS94ODYuaCBpbmRleA0KPiBkODBhNGM2YjVhMzguLmU2OWZmZjdkMWYyMSAxMDA2
NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL3g4Ni5oDQo+ICsrKyBiL2FyY2gveDg2L2t2bS94ODYu
aA0KPiBAQCAtMzMsNiArMzMsMTMgQEAgc3RydWN0IGt2bV9jYXBzIHsNCj4gIAl1NjQgc3VwcG9y
dGVkX3BlcmZfY2FwOw0KPiAgfTsNCj4gDQo+ICtzdHJ1Y3Qga3ZtX2hvc3RfdmFsdWVzIHsNCj4g
Kwl1NjQgZWZlcjsNCj4gKwl1NjQgeGNyMDsNCj4gKwl1NjQgeHNzOw0KPiArCXU2NCBhcmNoX2Nh
cGFiaWxpdGllczsNCj4gK307DQo+ICsNCj4gIHZvaWQga3ZtX3NwdXJpb3VzX2ZhdWx0KHZvaWQp
Ow0KPiANCj4gICNkZWZpbmUgS1ZNX05FU1RFRF9WTUVOVEVSX0NPTlNJU1RFTkNZX0NIRUNLKGNv
bnNpc3RlbmN5X2NoZWNrKQ0KPiAJCVwNCj4gQEAgLTMyNSwxMSArMzMyLDggQEAgaW50IHg4Nl9l
bXVsYXRlX2luc3RydWN0aW9uKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4gZ3BhX3QgY3IyX29y
X2dwYSwNCj4gIAkJCSAgICBpbnQgZW11bGF0aW9uX3R5cGUsIHZvaWQgKmluc24sIGludCBpbnNu
X2xlbik7DQo+IGZhc3RwYXRoX3QgaGFuZGxlX2Zhc3RwYXRoX3NldF9tc3JfaXJxb2ZmKHN0cnVj
dCBrdm1fdmNwdSAqdmNwdSk7DQo+IA0KPiAtZXh0ZXJuIHU2NCBob3N0X3hjcjA7DQo+IC1leHRl
cm4gdTY0IGhvc3RfeHNzOw0KPiAtZXh0ZXJuIHU2NCBob3N0X2FyY2hfY2FwYWJpbGl0aWVzOw0K
PiAtDQo+ICBleHRlcm4gc3RydWN0IGt2bV9jYXBzIGt2bV9jYXBzOw0KPiArZXh0ZXJuIHN0cnVj
dCBrdm1faG9zdF92YWx1ZXMga3ZtX2hvc3Q7DQoNCkhhdmUgeW91IGNvbnNpZGVyZWQgbWVyZ2lu
ZyB0aGUga3ZtX2hvc3RfdmFsdWVzIGFuZCBrdm1fY2FwcyBpbnRvIG9uZSB1bmlmaWVkDQpzdHJ1
Y3R1cmU/DQooSWYgdGhlIGNvbmNlcm4gaXMgYWJvdXQgbmFtaW5nLCB3ZSBjb3VsZCBicmFpbnN0
b3JtIGEgbW9yZSBlbmNvbXBhc3NpbmcgdGVybQ0KZm9yIHRoZW0pDQo=

