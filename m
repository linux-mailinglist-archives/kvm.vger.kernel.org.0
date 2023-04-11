Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5D2E6DD163
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 07:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjDKFGd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 01:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjDKFGb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 01:06:31 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCAA1FC1;
        Mon, 10 Apr 2023 22:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681189590; x=1712725590;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vszLJnZEn5v2fGHJ6jJX92tl9+EloPD5EAY/dqlyag8=;
  b=EifbJrtsJXfFSJdxJDvSK9Z4lc54DmIht8w9V2uSGJEmI2LwvbG0ixdj
   V9T8JyZwbL5KT+5JkSxei2GeSow+nL0gii+Qe8LzM0jRd7iXpa9+1e6Wh
   W5gndd3qGAyTKzp8HAfgjpacti/R0uT1O8quokd0XYphinVF98Ozj7Ozi
   5JUJYt9rQl11K5U0QKLUKzlLIuN5a5xeoVkhGJKD02oQrzOEb/TKHSDv/
   IgHm6GO6nu94e7XXOiXP1W6QkSwdoURit8KwNDB/d8qpNQkQ1sLKZTzjk
   TvoPNCK+LznE91Umv/QtxoGUQ3s3Z2N3UMbNkbnbQHSjtRTaTOHZY6t4O
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="345312905"
X-IronPort-AV: E=Sophos;i="5.98,335,1673942400"; 
   d="scan'208";a="345312905"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 22:06:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="832213642"
X-IronPort-AV: E=Sophos;i="5.98,335,1673942400"; 
   d="scan'208";a="832213642"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 10 Apr 2023 22:06:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 10 Apr 2023 22:06:28 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 10 Apr 2023 22:06:28 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 10 Apr 2023 22:06:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X1uwh83V/EcPs+lWP043+bzgr62iLn9V50mlhYOKM6wiU4UoM3IHDDOZhALJOq4vZLgwSCzMuUNIG1z5tpFD6gD3DpyylJYLEJ6XYVXeg0sD7nBEizZ84tmC1XVW2h/v9OwYKjNcYen70MnChUe9U3HIt/eKtcJGYa8sp3BbhomeoPrsuZtHYLji8HwZC0NYfny/m09vKGFam7qyQQXpTO+Cx58j/USlzc0QaqF0cvx9oXikJ8mzS8OlWE/iWqgFZwG3LirwN4utLdWB253ofj0pc6oYIu0k3B7iKk8tv4vme6WucWgGHPBkvK+GpZLb0OObkIDGvTaIvbJo8KC6iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V7uWof+7Xd82kHs1qfhv9mQjlXUVKVnCrgpTe2tohPI=;
 b=Qjoe4ZLN7btTHg2hwtcm+VBo9eXYy4zvKdboOisi5JtxnoMDZ2S8TAlZDca3jgVE8sOYt+tqJpsTa6xUIMPlOdpjFUBpI2h/M/VzAh/beHjz4SPwdfQQZVsO1YlsDfQMUnwkA8brmofLCv3iobEU3Jkc6mjZeUP+4G7w1MFa6PUaspf0UNH9v848wbZCHkAj+ItDi4cyuGTFg9FyU3x/J6PzKP7ujZJgMVtfu8lVEEuy+j6pM2uxbEe8IqJSsuAJg+hplWBIDgsQLMGNrXW08+CWSNCUoSl0QefY7AlRFfOdnCKGP66ynPmvXQmizTuWw4MxKvFSzgmhQMB8D9Twqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by SA2PR11MB4906.namprd11.prod.outlook.com (2603:10b6:806:fa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 05:06:27 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948%5]) with mapi id 15.20.6277.034; Tue, 11 Apr 2023
 05:06:27 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "Kang, Shan" <shan.kang@intel.com>
Subject: RE: [PATCH v8 33/33] KVM: x86/vmx: refactor VMX_DO_EVENT_IRQOFF to
 generate FRED stack frames
Thread-Topic: [PATCH v8 33/33] KVM: x86/vmx: refactor VMX_DO_EVENT_IRQOFF to
 generate FRED stack frames
Thread-Index: AQHZa4iiYR92PWeRCEi6WbUcy97+Bq8lFcEAgAB3RxA=
Date:   Tue, 11 Apr 2023 05:06:26 +0000
Message-ID: <SA1PR11MB673493A64E2BEAFA1A18ADE6A89A9@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-34-xin3.li@intel.com> <ZDSEjhGV9D90J6Bx@google.com>
In-Reply-To: <ZDSEjhGV9D90J6Bx@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|SA2PR11MB4906:EE_
x-ms-office365-filtering-correlation-id: ef8aacd6-3777-44e7-82ea-08db3a4a80f6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fRV+MMCqMNDh3eoIhvkGnSfFhEIIazzsmGITTRtt3HG0JhucrsQMftebfpFUVAsSRrk8sJ2m4qlVa/50ypYi+kEhCnVH6+gs4VKIipsRMEH1wan3PSsVdEs+qzhXhp16dr64xxMz7nIjRmngQ39iLJuOFaipinalLnQrnaVWtw/FPF/Rcp8dsvb3WzjZr2Ij8vEC+NGESfRxg4E5Ksoz3FNBcAWx4xgslP/xFSZTthkijL9OEM0nTpzj36WWJcx9BqzycK0RTPgrlZMhqCTJ/zEtqUiyssOvvNhtQnZxkLAUSNa9A9AdJLyaHnVeiuKhzU12jS/yFJyhEWbUiHr+eLNHrK/kXW+1Fq66GJn0uOKkP1CrsQixrBIBoe2vsZ2VkcPlB5JJKetLcKKCZ1QwRJGnYinndN04DDNS+GfVJRJPJfEUQ2yDW5gXmxT5reb3EKIlqPi63RqjZeugcVSaKlvwnMjO3dwuYBG/hpfm36wF9wIWd8CBj7jV3ODYDqwjgpQw3wXfeQclfSO5t1l5bARkyX6X6wYnKTj4MJAT+jWu32klU2Bi7uQPrRBzSlEI+LxY9mtq48PEHbUOnTJFUTlwI3rcK9hIA/E1WHxugv0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(376002)(346002)(136003)(396003)(451199021)(478600001)(7696005)(71200400001)(6506007)(316002)(54906003)(26005)(9686003)(186003)(2906002)(4744005)(66556008)(76116006)(66946007)(4326008)(52536014)(64756008)(41300700001)(7416002)(5660300002)(66446008)(66476007)(8676002)(8936002)(6916009)(38070700005)(38100700002)(122000001)(55016003)(33656002)(82960400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZCnLSQ7QtwCJy8L2cdDYqyV3UWW+GiDxJ/6dxm4Wcxb28vxFBigDL2OJ/evj?=
 =?us-ascii?Q?xdVLsWTAMhdeJQLLz6KFt7ogy9DQsYz9GW3q2E/YuNI3bXmkT0vtW2UoGoHW?=
 =?us-ascii?Q?V6ekxHOfl9QvAxiAQ8VW9mxtK7BcJd1SiBeZMprP9gokYfvdnbt6tdXljW//?=
 =?us-ascii?Q?5pqF6oUThPhu05+zgF42VNAPehTMs20bb/TZLSqVUPkR4FDwCpPpwgSDuLEw?=
 =?us-ascii?Q?dWVpdikZUr+fz2m51aEgRo9ww2Q2AvscEDpUTqEdyQCgV1PRpYDJg3+AiduT?=
 =?us-ascii?Q?SJGaK5YFkplBqIWqKf8W+hcDsVD2BHPR3+J4CcHn7dz4/cZELnKsWgtMzBYx?=
 =?us-ascii?Q?DJy1IjiXp+t99LatKWTcwVGSsdz8NRHFi/kMN8dR5jMzQxVAji/zDzwkNHBY?=
 =?us-ascii?Q?L7A74HEZjTdH7UHiV1S6rDZJfwUKmWTG9dJF7iFEmoNUTiFwdv0bTHWpURYC?=
 =?us-ascii?Q?Gc20y9IVM9DwLD4d4QoihY7tyBfTdRY+iy2H75dme2VRhid/K5e68BH9hzFR?=
 =?us-ascii?Q?y5S88WUBcVv/viv0IBqEqMGHng2ccaQwILnUpIRB52m+rW0O5SRRcWgsC0cS?=
 =?us-ascii?Q?m5ziWTem7tjewZivnyWgWXI6DkW0t82rp/uISQHhBwO9FXEp5tGMvCtE2zWl?=
 =?us-ascii?Q?JUIlfWyxmxZA0GrRU+T3/ozBXhfZnePTeHDAMatbE29cRcJI9LbiMyap7Nt5?=
 =?us-ascii?Q?2UNw46Q6Y12owxuhnszbiFmueMOoM+8tJmIuls6/4DMupOju39y44hD3E4vb?=
 =?us-ascii?Q?e26FwzXKHy7jLCkFUb9+L5B1ZTfbrieNp+L7FSjk2ch6a6qzTXTWZbZyfDWC?=
 =?us-ascii?Q?Fv+LYZuNqZSi3QcvTMBSLeKWPLjWe9BcPhLGxYtm12WMDw72WyD+LUL1JkqL?=
 =?us-ascii?Q?rKD7K+SwWcK/7NwTFzNry2vRZVraQySbAWtSAdTSxJ+6XOzeHWfvf+TeS3v4?=
 =?us-ascii?Q?rPKEFGgo6DEuTQf/tpINI4iRhlqOOjsmwXGUFCyOtiB2Z5Po0ZZw1d1kxCqp?=
 =?us-ascii?Q?qYQzVDNhUfIEUHhHpVkUKWWxcQXNOaaSLfuKjRqgugAOhk8aG3otCr2sFlPt?=
 =?us-ascii?Q?fQgBLEmiAzfEoZ4EHVJWJjJwABYQE9s54KlPwkBzcKHql/qzQm0+c54DFiiN?=
 =?us-ascii?Q?s0SWVN3sg310iOuveLvGuOTExCBqh66Ln6ScF22zu04AvQOiNBaNhGTknVYZ?=
 =?us-ascii?Q?t4Ou7cH87OvVi60RzYInFv9EfRg0lc86q9uepaLQQVtbTqrCTbJhzOzoof2m?=
 =?us-ascii?Q?HHD0d22HDhWHID4mReWHOIVkQbCu+ysuM6MuBxf3WEyvXUBfFroW9k8xVK8X?=
 =?us-ascii?Q?Q/aKIkLpX6OmMRidoloXn+ZnZX7R8geeIvWmoFN4hY5GvQdRm9AGmuO01VpY?=
 =?us-ascii?Q?6x492nunrymGRKyqNvLfDmWC9qqzYHa8ALAhAbXCInLTzx33GwHLiOY3WonQ?=
 =?us-ascii?Q?U4KBeScDIt6WAilwZAf92BlFn5b4ED2NXxQ9UgIVEukdyBNuTpCmTX89mS9H?=
 =?us-ascii?Q?f2evqvgfK34mtwJHetCbpiW8YHPBTKMfL5wayAJmSCyn1LwNXnNVQMs5Q0Zo?=
 =?us-ascii?Q?/sb8VPuSl6YQGPG7CLM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef8aacd6-3777-44e7-82ea-08db3a4a80f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2023 05:06:26.8105
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XptcG5hEApTwIxJ3y3b3MYWpyRGWy/I0vvMvyI8KCCVNytsMEBo6kcBjrNP+gCwNx1GgPKCJSfq6yy6sVlfeAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4906
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>=20
>  	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
> -	vmx_do_interrupt_irqoff(gate_offset(desc));
> +	if (cpu_feature_enabled(X86_FEATURE_FRED))
> +		vmx_do_fred_interrupt_irqoff(vector);
> +	else
> +		vmx_do_interrupt_irqoff(gate_offset((gate_desc *)host_idt_base


external_interrupt() is always available on x86_64, even when CONFIG_X86_FR=
ED
is not defined. I prefer to always call external_interrupt() on x86_64 for =
IRQ
handling, which avoids re-entering noinstr code. how do you think? Too
aggressive?

Thanks!
  Xin


> +
> +vector));
>  	kvm_after_interrupt(vcpu);
