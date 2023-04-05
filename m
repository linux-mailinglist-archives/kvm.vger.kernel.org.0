Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662E26D787C
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 11:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237191AbjDEJfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 05:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237052AbjDEJfl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 05:35:41 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3034559F
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 02:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680687322; x=1712223322;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=IvdIEyFpf3S8Lad6R2fd2wuHYQcEJCRioK5qnEaKHDA=;
  b=ir6YCCFZCnXXsSNHggKyNQv4Kb47PF480xWMm+JBJuzdi+ss1+WIl8SQ
   nNKLcas9lEfdYRNaxx5D3jCkZaLcBs4qUvkMQtcdub9gSNSUC4hoY/gXE
   CrqaDUJxUxQuoF/ZKID9FS48rJiFpKgcwj3+/h/CpRoGTsZn/Mfu61fYq
   ckwxTSflGIs+P3logcqWZWwBXgLiX32hoppXfFyapITvAz2JC+WvwAxj4
   7mr0jHWDJFu9EJdU1Gl/WM1O7xotfRLsdg/u75LZ561z1JRO9x48CIT0g
   7Zlbv7a06LFpJM1LOtvb7V+9s+Y83GO9pKy+iF/viAbAjpWlM6Kccd0dQ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="322789003"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="322789003"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 02:34:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="686683605"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="686683605"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 05 Apr 2023 02:34:28 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 02:34:28 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 02:34:28 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 02:34:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8h5OKLvmW7iXI4cMeFxLC9dWJ7xgMXz/SzWBo7AFip6GoZjSLIzrOhi+9WU0Y2cb6RKyF3Cg567NdG6CNO84Mo8edWq9DIVvz1yySNQ1QCb1s/1X8xsD+RKeCR/mUdpFuhE9iAYBnAH2Rjs53GYamv7FsTBVdrr1DytPnI0YDyrgvMmXbnNh8xPhJKRYHEh7HZpZxDZSXeXYMORSz9OOgG5jZAbH9zqOwoirIQiPfS3EpzrVt95HCk1A6II9WuKRnSTgjsuWakSB/s1NisMlgDGWYkRdrZyDjwFw/4Qyl+ALAkmQ2pDoZXWLNPxd1EQtNNtekWUgRdNwhiz7CIfZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u5Ks7YAavOT4ZQDaLCbylaCagP7d66eDl13QTcCXfCs=;
 b=OKAFzLukq3yXMYDAu/jIBA3DKshch44vq+xh+b82IdD2K00WZqhIV1s6r1YuXd9UIXfhDX74az0N6LGDInt65Ct6pW/HHngZhv6C4p0uGa+Lp8Zuq6vVpIhKqhjGV3EjRJRRxDguVd4ymF1tupzfyMEQnxVquNLP8TocJmjsuJOZVvq2CN0TVnNAC4q21dQCoKDDUqx1a96fjzigGDZKdVRfmtl/a5R+5hGj3nPz7YMbKofaKEPl1aEETYPBC9ajc11mBAPWckMRsZbW7W30+N36YxWvrClOfKlAHD0Sa7g1vdtv/d6q44Qu9AL1xtfoeDzd94itYUoZ3nT+mtpKwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by PH7PR11MB5958.namprd11.prod.outlook.com (2603:10b6:510:1e1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Wed, 5 Apr
 2023 09:34:25 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948%6]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 09:34:25 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "Yao, Yuan" <yuan.yao@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "H.Peter Anvin" <hpa@zytor.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
Subject: The necessity of injecting a hardware exception reported in VMX IDT
 vectoring information
Thread-Topic: The necessity of injecting a hardware exception reported in VMX
 IDT vectoring information
Thread-Index: AdlnGoO7DMFQx8JhSoqsl2dQLdydDA==
Date:   Wed, 5 Apr 2023 09:34:25 +0000
Message-ID: <SA1PR11MB673463616F7B1318874D11A3A8909@SA1PR11MB6734.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|PH7PR11MB5958:EE_
x-ms-office365-filtering-correlation-id: 67aed4f3-6353-4116-3ba4-08db35b8f206
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uSzpQdP3cj1t7dPklnSN8ysnMCbuwDkoPf+l4ZuWpuUYA0H8WfQmnC07e+hzHmyjCvYBNSYsDHSeTvAn/Pn6CtBKXNZWMb335yxIU58o4r/QaN6TSSOt0KFrqBOOL9T9I2hdW7ns1RgTyWdKvw5etWEriRs3ULthkhpoLXMaiZ097qEgxK6Er+mzoDNiKnvfa9JdIRtcgkAfFHMBftAy9kWHANIOp82ds4T0IIoDVh2tI5URJig+kgKCWzfxob2iJbNyTVaLjxVk3ExxgiXp9Plqa4oGDrJUkFtHup4nAsVjWixh7FaNU5uHlY+YSlNI5b+ivbqv2JDhLJryxgrGWj9ufxdWVItY2W982dBb8PLL/wJXISvGM9bl0FIyiOnK8Yftry64CB3MRzM5lVGIaFQ4DY7mIlkzb9ZN2DBsW4eSDPUSYHaVYhg21ptmbkTFVPkqViWH85vEcgbjfjt1P0GNmB1f5Khu+LOVTsNA5Eo0O5wA7mco/HIm2tfWAWgxn9ZEzEnGmws+49rwDvBlY/IJDuGcr/UDgKj3AHlIyT9RBeTo59tJUW2e7UvF+kelhc/gKuT+QTKdpEHLN7oy/crqLTUSX+eEzBX9RP1bBBn/d35BifGKyupuyuM0ryI9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(39860400002)(376002)(136003)(346002)(451199021)(86362001)(5660300002)(6916009)(107886003)(186003)(122000001)(82960400001)(26005)(9686003)(6506007)(38070700005)(52536014)(8936002)(66476007)(8676002)(66946007)(33656002)(66446008)(478600001)(55016003)(76116006)(4326008)(54906003)(64756008)(41300700001)(316002)(7696005)(71200400001)(66556008)(2906002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ae7zOHaBtrSoAbp71uFQs++GGEfMRNN5DOqtJq8uIQlYrVgNVDiWqwAzMv1i?=
 =?us-ascii?Q?zOhcjArCTy2uFIcfipMJ55w453/GDXI/iukFnAEqvKnWYGQz/sem+jMjUrZs?=
 =?us-ascii?Q?RKeXINrakomK+kIpfuSjGZHQTm6nKVYipL+OZuidhEk7ddL5qtoEufk+aCnK?=
 =?us-ascii?Q?s9c6bhqMm7TZ+KvD4iCtFDWqFTfGcjSmmVgbV9wgg78aDJsgqdz68SDrir4T?=
 =?us-ascii?Q?AyDXWoVHweVm0RXrga1VOIfrAWGyw36NoJ3ITffikUNnSmj0M9ytXzf/2fjB?=
 =?us-ascii?Q?D3X+UyeX4Ie1pqojEcRZpPt0CNwqOr8yc539unNrn6kk3dkPLfc6+Uk8drmq?=
 =?us-ascii?Q?RjOF8+UNzOuJ+dv1xViVOns4FGEnJmMxxuU7k/qm+wPk8ZotiZSGjoPr9Tcs?=
 =?us-ascii?Q?NH1QH+m6dRfQVSq9LhEJezR3rC8UA2WHgc18azlo0lXVZLqSDxzdiMH39q5S?=
 =?us-ascii?Q?G4Y4Loa9ELJBjhJ6xoJfz/6oTmgTsRH/95mZrxSn0bFCIBNAsGpUIa55MOnt?=
 =?us-ascii?Q?m+qaSwwcUNIR5Xkmu3WQux5zipD81bvPnWBGEA8O3EzsrolTFQZThRSCuSyN?=
 =?us-ascii?Q?XmZ0TdeGBOL2UL0oCK/KVQDfXWPWELXP1KybkV7YueewlkXFf5uVu6AyUmf4?=
 =?us-ascii?Q?rLPV+fTmqCsZ+6TBAbOQ44LFc3fbvlWZNkdq5hmtx4bxBQ7cCi4ykgAjDsRS?=
 =?us-ascii?Q?Qt57U9+rHBwFdpLkxb8oBEOI+Xv3K2uz5H0yFyYe8okTZ1oReWj8Nj+nECPc?=
 =?us-ascii?Q?MOhjA/B77YOuD8Re654li+F594EmhuUtWW5OaWRD0ffXggQ8vMKrI73+R8Ty?=
 =?us-ascii?Q?KaIsANAx+NVniwvrurS7/S68ABx7coXaMYYh5K6YPrDdyOsinhnP3KENRkoF?=
 =?us-ascii?Q?atHt6f1abIV4wSqr+69+n5z/ZoYf2fjn+PszJFvEhHDesQygM2Mh8PyrXMcU?=
 =?us-ascii?Q?Ign626A273XqJAOzIzd6p+CXFhO7S+OdFSVBGk5rWzN1VB8kZE+bqoUpjq3D?=
 =?us-ascii?Q?mKLPD9lPRRxsawXW+QF8PGaKZvRDLCnTqhcKQzkWsqYhWf/B/glRjHEjbWZi?=
 =?us-ascii?Q?348G816EaVSYjSx+vqkC/KvE6ln72XEt3ZbDh/NRJqbj1kHGfmJJ+Gw25yeQ?=
 =?us-ascii?Q?UxGlY+SCZSjxzaOItMOseRtjUhWIzpodqO6x7KaGLn+xz06TaH6amo0HFJDq?=
 =?us-ascii?Q?0tyzUyw7m4N/t3zTOmr7QKZgdvrPXK7iWukO7TYFUIRYWz5/y3MfEd90FAEd?=
 =?us-ascii?Q?eaBE0OcXjG90UPQY4PGaTX2WrcZZIsRZVH2cgDTm4p2ZXC2lNsWo115kBMIj?=
 =?us-ascii?Q?NaEQePWiabKHtI+hT8zhN3Yn0ZyiqFwu4JFxBhwjs3vQXkwNblWW/BQLCTo0?=
 =?us-ascii?Q?yOA/9bKAUGy1zAX5cWNE8H1uj5Q7a8WOUgeZBrSDRrwIXQN4QaM4RuojFsYk?=
 =?us-ascii?Q?zv8QKT12NQ4bPVn9TmsK7OT42NHs7GRUmeWHofE6jwC2eItJdBqVpuQdGnVS?=
 =?us-ascii?Q?RLjIEM8w2gAQsoqKDbqzUy+YQpZW0Xvy1yU5suDk1NwYj8fduQBMCajW0q+4?=
 =?us-ascii?Q?HHl1m8SvsjI/nvJ2iDc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67aed4f3-6353-4116-3ba4-08db35b8f206
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 09:34:25.3683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tJDPDibuXuWRvIRksJZjn2UN4McC2tlFsL3GDOA61CLGhGePLFUwiGWw9vp3K+S1a83aYhD1peQkLxaxKLqnzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5958
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The VMCS IDT vectoring information field is used to report basic informatio=
n
associated with the event that was being delivered when a VM exit occurred.
such an event itself doesn't trigger a VM exit, however, a condition to del=
iver
the event is not met, e.g., EPT violation.

When the IDT vectoring information field reports a maskable external interr=
upt,
KVM reinjects this external interrupt after handling the VM exit. Otherwise=
,
the external interrupt is lost.

KVM handles a hardware exception reported in the IDT vectoring information
field in the same way, which makes nothing wrong. This piece of code is in
__vmx_complete_interrupts():

        case INTR_TYPE_SOFT_EXCEPTION:
                vcpu->arch.event_exit_inst_len =3D vmcs_read32(instr_len_fi=
eld);
                fallthrough;
        case INTR_TYPE_HARD_EXCEPTION:
                if (idt_vectoring_info & VECTORING_INFO_DELIVER_CODE_MASK) =
{
                        u32 err =3D vmcs_read32(error_code_field);
                        kvm_requeue_exception_e(vcpu, vector, err);
                } else
                        kvm_requeue_exception(vcpu, vector);
                break;

But if KVM just ignores any hardware exception in such a case, the CPU will
re-generate it once it resumes guest execution, which looks cleaner.

The question is, must KVM inject a hardware exception from the IDT vectorin=
g
information field? Is there any correctness issue if KVM does not?

If no correctness issue, it's better to not do it, because the injected eve=
nt
from IDT vectoring could trigger another exception, i.e., a nested exceptio=
n,
and after the nested exception is handled, the CPU resumes to re-trigger th=
e
original event, which makes not much sense to inject it.

In addition, the benefits of not doing so are:
1) Less code.
2) Faster execution. Calling kvm_requeue_exception_e()/kvm_requeue_exceptio=
n()
   consumes a few hundred cycles at least, although it's a rare case with E=
PT,
   but a lot with shadow (who cares?). And vmx_inject_exception() also has =
a
   cost.
3) An IDT vectoring could trigger more than one VM exit, e.g., the first is=
 an
   EPT violation, and the second a PML full, KVM needs to reinject it twice
   (extremely rare).

Thanks!
  Xin
