Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C8741856D
	for <lists+kvm@lfdr.de>; Sun, 26 Sep 2021 03:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhIZBpO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Sep 2021 21:45:14 -0400
Received: from mga05.intel.com ([192.55.52.43]:19447 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230254AbhIZBpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Sep 2021 21:45:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10118"; a="309860954"
X-IronPort-AV: E=Sophos;i="5.85,322,1624345200"; 
   d="scan'208";a="309860954"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2021 18:43:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,322,1624345200"; 
   d="scan'208";a="705324511"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga006.fm.intel.com with ESMTP; 25 Sep 2021 18:43:35 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Sat, 25 Sep 2021 18:43:35 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Sat, 25 Sep 2021 18:43:34 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Sat, 25 Sep 2021 18:43:34 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Sat, 25 Sep 2021 18:43:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0GR6gXNR+KkQGwnS48775xVhHSVe9CKuXFn000hKoLOMSWpv+qnki3mQxKxCiGhAoWziC+Y5e75lvJuuR3dLHSEDhLkadg2vJbpR7WoYaXopiWpCL9dTflMV/ZUGk7pVZKSl4gZYK3mi2ITZPy+ryDdXUPs4q4Q8VRhRf59jyWNaUPt5ENr6ZzoiHxUf148+/cr3G3gV+jRQ58oHZjq98fxCJ/vAv9BeUKRRDYne/7SDHDX/5LBRQT2ppS7G7i9jO4ooUXJNfubakPGeeYvN4OiPgwrMY+yULbR5rItpMAhjfmJ/Jx/vme8t02imG1d3bW2xc+K+NI/od3AsY6zFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=fMwzCSW+Ky2S/49yuIp5wnlAxFX4JlY4DXk8XA57SgE=;
 b=GTpt8gRgCSFUQct8ONi2XvJK8Tvq+jsS0fKrXOnRdwk4Sk6jtGRh2A7qOPZDkzT2UfRTz+7vvX6xFd9zq35Ru1NjUoTmK6XypQmJXiIE590+hYAQui/ImQtbQSyP4ADHFAvclAPL9IcRTDbmX2fMIDfqcIDx3b6J314j3wtnXQZMkX/q9qeojDrG5SngWd7Zmzup4/GWb5oavU0xJqVcP6OuNdzQhnpRhY3XyijpcE7/LdsvFafyD5vATMkUhHdjXKYUrWXwhdj78JtsRNUUBG0RuAaDBZ6pPnxGuCqvbTY3seKe5/qG94JTd99kDUu7bp8vSTC0nH6XDSrE9c0fgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fMwzCSW+Ky2S/49yuIp5wnlAxFX4JlY4DXk8XA57SgE=;
 b=TQaPYnih9bjkyXri0lk7H/mTxGs1wECAJ8l2n6foUuP1qFo8scgUc+dh43xpIamRdJGzU4nIywxJ99vUOIm8blAhPIgVphwwrXO1mdEj5F4SQCyLnlH1UPQZ42hOl2fBU3OMWy0MfWV9NWJObconWZBZLadMl7Efycqg0cvFaHo=
Received: from DM8PR11MB5670.namprd11.prod.outlook.com (2603:10b6:8:37::12) by
 DM8PR11MB5573.namprd11.prod.outlook.com (2603:10b6:8:3b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.14; Sun, 26 Sep 2021 01:43:33 +0000
Received: from DM8PR11MB5670.namprd11.prod.outlook.com
 ([fe80::78e6:9c8f:d36f:189b]) by DM8PR11MB5670.namprd11.prod.outlook.com
 ([fe80::78e6:9c8f:d36f:189b%6]) with mapi id 15.20.4544.021; Sun, 26 Sep 2021
 01:43:33 +0000
From:   "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>
Subject: RE: [PATCH] KVM: VMX: Fix a TSX_CTRL_CPUID_CLEAR field mask issue
Thread-Topic: [PATCH] KVM: VMX: Fix a TSX_CTRL_CPUID_CLEAR field mask issue
Thread-Index: AQHXosCKZyngCX9ZDkW4FcXraUV7iauZRY8AgBxkG9A=
Date:   Sun, 26 Sep 2021 01:43:33 +0000
Message-ID: <DM8PR11MB56709E73A02D416A99AD706692A69@DM8PR11MB5670.namprd11.prod.outlook.com>
References: <20210906014323.170235-1-zhenzhong.duan@intel.com>
 <YTf+ygFFLWdHXHX3@google.com>
In-Reply-To: <YTf+ygFFLWdHXHX3@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.200.16
dlp-reaction: no-action
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a764a80e-b91a-4489-41e6-08d9808f0d19
x-ms-traffictypediagnostic: DM8PR11MB5573:
x-microsoft-antispam-prvs: <DM8PR11MB55736D9E7B1C1BE211609AD092A69@DM8PR11MB5573.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 882Ln/tFhHJ+uMDO8Zu9dorYtg1+R4XTh6gyNu1JL2WcYczkNl1CNX3pydPKf1gKtVn8qEbW3kg3fHd4jyNJ0SRi8Y61eGnAaJ0afI3ZplLuObfN3aNMstt0ypOFUQup5Yt1lsY/aix/f0NjrJlxVAPJxa19ePTPJhIVOj3rJtulfj0v2YKnW4ig1M2eNIeif66u6+3ke1CR5JO4hIPr1REYXmwxVGtf0wLBUpo6B65+WA4rCx6i6+EII4Z1262aPsdJfGdysrytMnUmPO//lAZSZMsQsZYDANLf5iayKQRnB4bEwLZ3xbUKq/YmKDaLKsAUVr1aPwK1doPOTveis9TwZBBwfyNqydNvRLHV/5Ym0BhRP6B5LtgN2ZQ8sF/dIuxMvXlFFlma4nZwHqFZD9vC2a07U5xOdNFNsKl2yxbjHgHR/Hjpy2jGuXg5Vj8LSmJLXkogTwWFcJ2yKiGjJE8G+WK+iC8/pXTILnUs1B+24knx18NZQPfbt41ysx/b+k8DSKALjiQSHZhrYAyJt/zE1rtnxIyx8+SjLxExbincSr5u3PBHDtYO3GX5iwi8dfhDdyyQZZkh7KdMcL0xDBCt4rFcl3IFap5Cb3hs65aBOC+jAlTnxc7S+X8yMJUnN0HluXjvYAfNhAIvfPDBCr5xqZRmZvFBvUYmBa9oGtWTzr04sUK9MebyFAFmllnRbqhL3SxTKlqlWe5nV2O2QnqliAp8Xry8Yjh5Mx3HIPI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5670.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(71200400001)(7696005)(6506007)(2906002)(122000001)(186003)(26005)(83380400001)(9686003)(33656002)(55016002)(508600001)(38070700005)(86362001)(54906003)(8936002)(52536014)(8676002)(76116006)(66946007)(4326008)(316002)(66476007)(66556008)(64756008)(6916009)(66446008)(38100700002)(5660300002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GoilWgiFGztPvlzhlzd47X4iUZvppClig8znFJTS6XbkwyPQoJIZE43dFfUO?=
 =?us-ascii?Q?eFrPcXrdk0+ImTpv3JSntpAJFvaqO5AvcoHysppX34l27boXvfaQOusG7PDz?=
 =?us-ascii?Q?yXWZyrutHnntI5igxuDMlndnjCz3WDn+91ExXPHiWsLfTg/VKBLTlJDPv8Zj?=
 =?us-ascii?Q?mQxGE66pADYSwuC5gmGGL4+bwjIHoLH/7R7RTSPg/AhT6/+ono3ULpDqqEui?=
 =?us-ascii?Q?3K5eHlfonHMGnIIdD3P/it5Fxf699ORWCL14u13/cqgY2ZnMhU402Ha5e5uc?=
 =?us-ascii?Q?x/NaIAFiSdr5aYD37LKdMaDBINAA03WzxEfOYNE7lKovDnmZymfX0HuyXD20?=
 =?us-ascii?Q?9sX6iuQh96WPGkyWCD6l1hvZOtBTKiUvNiXHn8FpYPGIVL6Gp5zjB1EHrbu7?=
 =?us-ascii?Q?nvFD2vnOzbKrvrg0qPfMglYxoPoUg0j6VURwoPq4+cB5iZaChkWfVs3Dpc6w?=
 =?us-ascii?Q?DrxkA7G6GN33jLmIo6CYokOuuy3qONShZdw1TlnYyMDQp5qTZZD341lGdefa?=
 =?us-ascii?Q?X9dVY0yREe82GQ9u2I7XChtSP6saPS15hzfaQd396+4mTvgiWrJRj+jb7Gpl?=
 =?us-ascii?Q?UsqfPe/5/b09xanipcRWdNTk3Wu5K67a760YR1AFliy6Wc3KdRWQtbA02AM6?=
 =?us-ascii?Q?qedavL32ijx34VaJ2h3bfQ+PqNv0mjJgFTG3esKcdCsLVHsRDjR36th8pFV/?=
 =?us-ascii?Q?UVag5g6AHpDPu5VD5n5pY4cWrYrMraX2D6TxjYBMLA5GeW9wt8O+yzqTFDb4?=
 =?us-ascii?Q?Say3rt+6M4GbaEA9ALZ8TQgYrikbcYXILQ1ykYtvB2SX7N/6SkPMUmFawa0e?=
 =?us-ascii?Q?kxs3AhoCdDdq4bAio+4mnDBjZjrwLwOH1bDiM9YQf2lofg22LUPDyqxnyGZy?=
 =?us-ascii?Q?ZPgND7QK6nMY7IwhZOVpqj1Gh7h6mmfso76oIsUq97ir5oS7adA8os5SWaws?=
 =?us-ascii?Q?CVecl3mY6147jA4V78Gia7obX3enxpPF4+vgw9yqfBuFHWCk44FLYuuZRcqd?=
 =?us-ascii?Q?ONlo2CkwSfOG0bZsUwSrITAS0F4HyXglP+zxP9ppx63Gdan6V46tSvW3uL+z?=
 =?us-ascii?Q?MSjP7rPyTC1tU3ODv7SyMiWY4/T4M3YThQ4mJGExyupvH0yN9XN0iVfymaLs?=
 =?us-ascii?Q?GKyTQJX+FEWdxekVrHutoCotsGCbPjE30/4JE9eSF9JFGfs+0iF6j/PwcDmC?=
 =?us-ascii?Q?Ucm0nM8c5ptWpvwzqW4Dn8ebcDhQgZlgekeam+MxMw9UQUMARt77povtF4yv?=
 =?us-ascii?Q?LUv3XW4vU6yyUXzYLWh7HvmX7nEkUTMRgDrL8kVraUmkrHHS7xRbTaEKhFQX?=
 =?us-ascii?Q?Itg=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5670.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a764a80e-b91a-4489-41e6-08d9808f0d19
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2021 01:43:33.6520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gG271sVQg9U27ItpLF1PlC8Y0P0mKA9DWCT8hvTBIwvX77VLIV80TVhYFSjl9I8NytLkaX2NtdxY3mSsYhVdhBCKZIfQlxd7ghbYS1KFfyE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5573
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>-----Original Message-----
>From: Sean Christopherson <seanjc@google.com>
>Sent: Wednesday, September 8, 2021 8:08 AM
>To: Duan, Zhenzhong <zhenzhong.duan@intel.com>
>Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>pbonzini@redhat.com; vkuznets@redhat.com; wanpengli@tencent.com;
>jmattson@google.com; joro@8bytes.org
>Subject: Re: [PATCH] KVM: VMX: Fix a TSX_CTRL_CPUID_CLEAR field mask
>issue
>
>On Mon, Sep 06, 2021, Zhenzhong Duan wrote:
>> Host value of TSX_CTRL_CPUID_CLEAR field should be unchangable by
>> guest, but the mask for this purpose is set to a wrong value. So it
>> doesn't take effect.
>
>It would be helpful to provide a bit more info as to just how bad/bonehead=
ed
>this bug is.  E.g.
>
>  When updating the host's mask for its MSR_IA32_TSX_CTRL user return entr=
y,
>  clear the mask in the found uret MSR instead of vmx->guest_uret_msrs[i].
>  Modifying guest_uret_msrs directly is completely broken as 'i' does not
>  point at the MSR_IA32_TSX_CTRL entry.  In fact, it's guaranteed to be an
>  out-of-bounds accesses as is always set to kvm_nr_uret_msrs in a prior
>  loop.  By sheer dumb luck, the fallout is limited to "only" failing to
>  preserve the host's TSX_CTRL_CPUID_CLEAR.  The out-of-bounds access is
>  benign as it's guaranteed to clear a bit in a guest MSR value, which are
>  always zero at vCPU creation on both x86-64 and i386.
Sorry for late response, I missed this mail by a wrong mail rule.
Your comment is more clear, I'll use it in v2.

Thanks
Zhenzhong
