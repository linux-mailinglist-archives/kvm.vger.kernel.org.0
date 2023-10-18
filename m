Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3427CE854
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 21:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbjJRT6U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 15:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbjJRT6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 15:58:19 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA4911D;
        Wed, 18 Oct 2023 12:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697659097; x=1729195097;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=b51keTvs74PmwNNmuwKF8ljn+hboHUyj8N19nOqhfZA=;
  b=AGi08hpjLTGIiO0RGxMK6Bv4a/GdgqYpI6UWf2CSdXE3CZ5MwA2F83P6
   hbSsTRL5vNr1jf1wAo1lvz/75Ec9bkYeX2BrNWjAU4m9M/gIkXhhed1KA
   FusU6/+fOe7fjZco9Ht3tMAsCjS+hDo63bAZjVo+iznOiCczt546dsa5m
   IEFthehKip3rFhPAaEiLVdk2oi1wLJajbWoJBYTKTjXcOvBAL4EwYo9pK
   2lnvZDP/YAk8loWd+lnqxf2TYFoLFyeZ8+uNjalINX79+9rAPh7w4QSVH
   nVCFbAF5kF48pjjUVmD2VPFFz0cM5twvUojPj2LFPA6Qi+3/07W2NJwN/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10867"; a="383317737"
X-IronPort-AV: E=Sophos;i="6.03,235,1694761200"; 
   d="scan'208";a="383317737"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2023 12:58:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10867"; a="750227117"
X-IronPort-AV: E=Sophos;i="6.03,235,1694761200"; 
   d="scan'208";a="750227117"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Oct 2023 12:58:14 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 18 Oct 2023 12:58:14 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Wed, 18 Oct 2023 12:58:14 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 18 Oct 2023 12:58:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JDGefYCRB6YJaoseaMZeInc9av6nsu/t+BWd265vlYel91WSCBCV0oWoTR9u/t3cHqEyAak3k9+0rNehoSFbCVl6UzjfGqhHuQMsVHY0o5xqrJx2foHf+OD4rWLXKvzUNuMWH3n+5vdkohosR83fyZ6JKJOjgz/bYtOR6xCAxSUXXNoeWykQD/rT1FsTHpuzJqhQOemQAyqSF0jquQt+B/HCuh1e60xWZiH8h+sWr+AdDkXvNrYfQoCyDP9jtOQPtxSEy9oTVlZKtOAaM5Bb63B/O4AqWObeHRursU0oRqLmv5cRDuQWT7YaUpJJCjt2CqhSOSk4gGE90xXeYA/o+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cnXFRT8QxFUGRWInX0u/VGuz74I6OwAwsT5aSon5Thg=;
 b=D145xGM80QCR5whYOEyP7odgEADvQepS8u2y9TFNxp1PsEnED4oX8QnGwKE5IlRNxsAPpdQfm4iomxnDChe2ZlVcOncyaBp3Z3Gp59cmMoTC9b+zk/xmzNLEGQKKv0MN+5YrtvYChmcl+H823nQjacJbpeDhDkFXEmU9CPqC83PPYK3RU/MS6iroXiu0fO1ginTCgB1DgjS9mP2Opy4SNZkeiBi+w92o5SPdDNUbwmTSO79CtJUzoBGj9v47E9LVCW5Sr7TkUrRTyKSu6bQPwqyZdp3aCCxvdhnhumImC2UI/iwfXiMQPRV3/K30nIxV6J6OM7FsHP96sbv1xoaiXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CY8PR11MB7291.namprd11.prod.outlook.com (2603:10b6:930:9b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21; Wed, 18 Oct
 2023 19:58:04 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::7978:1ba5:6ed0:717d]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::7978:1ba5:6ed0:717d%4]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 19:58:04 +0000
Date:   Wed, 18 Oct 2023 12:58:01 -0700
From:   Dan Williams <dan.j.williams@intel.com>
To:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Lukas Wunner <lukas@wunner.de>
CC:     Bjorn Helgaas <helgaas@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        <linux-pci@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <keyrings@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linuxarm@huawei.com>, David Box <david.e.box@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        "Wilfred Mallawa" <wilfred.mallawa@wdc.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH 12/12] PCI/CMA: Grant guests exclusive control of
 authentication
Message-ID: <653038c93a054_780ef294e9@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1695921656.git.lukas@wunner.de>
 <467bff0c4bab93067b1e353e5b8a92f1de353a3f.1695921657.git.lukas@wunner.de>
 <20231003164048.0000148c@Huawei.com>
 <20231003193058.GA16417@wunner.de>
 <20231006103020.0000174f@Huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231006103020.0000174f@Huawei.com>
X-ClientProxiedBy: MW4PR03CA0271.namprd03.prod.outlook.com
 (2603:10b6:303:b5::6) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CY8PR11MB7291:EE_
X-MS-Office365-Filtering-Correlation-Id: f8cbb68c-14fa-4f71-335e-08dbd0148a5d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1q7Nyyn3c78v0KJr+qcVpPVkQwIY8xH3LmePN0JvnWkPXYpVBr2t/cvj2FYCkPsT5xunWLlRF2W76EO1DKXva/seyDd4mo7vS/l3sQaI53Rd4TkRvY1qzs7CtLMymxT3l/N2wuuotHW4top/vYxOvMuetBYt9Xg0azW5tHxSIDCL6+yudpOcWcDoMKuJbqkCzjNmwU1Nk/6wPx+dDcWj4Me1xMd64gWL9B0UkDKHnYYg65E+aYaVK+cHkVapzqVf+sgKoapPwwFBHHHXAwn3D/+l8ZIFRvGaYXhX9Kw8i9RiQKioOhaHY8g2hYH2svgRY5c0CFA759IvR2CF0YF2wLpeHuTirNrSdHZvS3QFls5nGmmCVCfNYapDjWQ1wjK9i2e0nYkxnoCJWR47gbH7cf5CNSTa7A/gClPAusGyHMyOpTZEafX5Y5sWIyqM9+p6mODsWCy5NRCp++Tq3K7dXA3SFR9f7env8bPNpZeWi3bKNenywTJnhX2p/6cLHsI/69xHCqIwLoAmk/yvQW0J9kk6PVub5etWCp5P0LUJfcu1pBhQQum720ZYdqowfkwX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(396003)(366004)(39860400002)(136003)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(66946007)(7416002)(2906002)(86362001)(4326008)(41300700001)(8676002)(110136005)(66476007)(8936002)(5660300002)(54906003)(66556008)(316002)(26005)(83380400001)(82960400001)(6512007)(38100700002)(9686003)(6666004)(6506007)(6486002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Aawo2S6LfnPzWvyoxHtVrFTHQXN27J9dCWT95JQEvLysXb6EKauXmYGBfgXe?=
 =?us-ascii?Q?BPWQtJNu0RUCe6ZyMD6NabYoemfKUPuMUQ23ivap8mhXma0gp+WlY6WxnI9E?=
 =?us-ascii?Q?a+DeXR0DijT6k2/pxo9dtkoJBYA2HhEzuaxJgzQCYjJ+Tb5K9jAARVN163FY?=
 =?us-ascii?Q?lhO4uzGoFqeO9Kedw08kslTkFgZvi7aqiZ7IsfRdOl84bJqZoZ3kkAnPd14G?=
 =?us-ascii?Q?hEITZPFJpbosxn3nsxjFTgVnPukuKAWtcOlkCJBVfXQ78QRPDUUDyejk9ZOB?=
 =?us-ascii?Q?8VYmb/Bt1aD18x4e7xStJMhETftAQlAR0l0W8ZiVhE/2jkePNSle2G7olc5O?=
 =?us-ascii?Q?TmCRVPpbmiOJRU3QbAn2dT5OUr/IOuSEMq5ln76u9LELJUAi7qN3PCRChasM?=
 =?us-ascii?Q?/oZO7smxBAWu3w1+qgj17dit3HOEKU/0GOoK/I7GEh6KwPd1RtUgqk/ijn2g?=
 =?us-ascii?Q?2qbjGxOsUpMYZkQdvoYU678Xbku8GTPNFMLjlBOTC81n+60QWzbkpR6F50Et?=
 =?us-ascii?Q?ZFyhHY75sl3IOLVRwbX+7OkR0WfzJwunmXajCoI2KtqB0aDUJvW0PkJwvdIX?=
 =?us-ascii?Q?+tiD6HD6ST71zS6zzCJq0ksJi6NmGDOFQg69WsvMiewuS8bXGsy8U94EbYnn?=
 =?us-ascii?Q?OChYvNAR6k/5fdAdSf+v0FIUfV1ZJYY1Cxtx/OgbmJyKFE2EaO7IjCHsdIRk?=
 =?us-ascii?Q?CCJxJ2oPdqSuZ3azXltJMqcKuCsi3H2QxPmeAAB3YaA0+manqOyxPgiWvlOo?=
 =?us-ascii?Q?JL+JQ8BORlDrKiFScoEyJi7mf+I/pBr9ZMWWfH5yYVMwB1KG/an32VWskJuW?=
 =?us-ascii?Q?Gw3iEkkn8boRl1mwRpZeNLFfI13fMojTe43N+LSJdTX98TR3FC6CV8mzc7g0?=
 =?us-ascii?Q?0hG85wyJuKaoBMT6OQq+C6BMh/SVgl8PnUeib9dmatsESN7T0/NgdMtaB+g7?=
 =?us-ascii?Q?o1OLicKUtFtV/dbE/7lulVeb0fZQgM6FW+2KfbLIHProR/4mtFMPKub4FK5U?=
 =?us-ascii?Q?1E13qm3St7vgSFCYDqyov6bN87HLbo2sl7++tJ76vdm9Df95lF8oCU3PVZHF?=
 =?us-ascii?Q?DZozaagQGKND2VK9ubOp723XpUeDSm2aU5Fn0P4+YQWW9lRV3hwCDFbPJQ0z?=
 =?us-ascii?Q?nKC7tYj3IUFvrbfWq5bytwDq7Z3g2JwMkysxucX9LqF2QWLb2LD7EW0r4NvX?=
 =?us-ascii?Q?3n1GJ5dVsFld0e5j0ZOuLglPpnLWoKlSuU2rBvfRDBWAP0I3wgHDylw33T3r?=
 =?us-ascii?Q?vSdrxWDRnsLl06uvoqlVQuOwt4GE22l9+yd6VSFiJPvEkWZmvSHC671e4xVQ?=
 =?us-ascii?Q?acPiUvsqnCfMy1VOUUk16WticeDtSSqMDg2xp1YJIUL3fgQmrSvZ7crb52/X?=
 =?us-ascii?Q?ksa0eN6PW1pwOxmnJBrx+1hwzpz7cVwrv2JxwvrjyMiMXaF6oRewvTD7CCt7?=
 =?us-ascii?Q?L9WjHk5C8eab2RrMWIn8RUOrhfDaW+lYbZrGQVDgLNAk1DyMj4qBmL/2n9Bf?=
 =?us-ascii?Q?q6HuS4KBxfxtZ3qT2ZjH77c8eqhf40wLEj0qBBFYpal52LRY4XMB6gRqB11T?=
 =?us-ascii?Q?b8LwEaQwbxXWx2i3hEMAg7xzO2/+jxyP8poBSDr9FFKG+8EW54fndCcabFPH?=
 =?us-ascii?Q?Cw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f8cbb68c-14fa-4f71-335e-08dbd0148a5d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 19:58:04.4330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xSizCBDq5dXuT4LJ7l18pO4VChexfHWY4a+JuuY+um/u3yaNMxNjYculbBNydcThYpdTD4ggxMNfpH0kPuDrwWxo716XISW8OkAXV3JEFso=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7291
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jonathan Cameron wrote:
> On Tue, 3 Oct 2023 21:30:58 +0200
> Lukas Wunner <lukas@wunner.de> wrote:
> 
> > On Tue, Oct 03, 2023 at 04:40:48PM +0100, Jonathan Cameron wrote:
> > > On Thu, 28 Sep 2023 19:32:42 +0200 Lukas Wunner <lukas@wunner.de> wrote:  
> > > > At any given time, only a single entity in a physical system may have
> > > > an SPDM connection to a device.  That's because the GET_VERSION request
> > > > (which begins an authentication sequence) resets "the connection and all
> > > > context associated with that connection" (SPDM 1.3.0 margin no 158).
> > > > 
> > > > Thus, when a device is passed through to a guest and the guest has
> > > > authenticated it, a subsequent authentication by the host would reset
> > > > the device's CMA-SPDM session behind the guest's back.
> > > > 
> > > > Prevent by letting the guest claim exclusive CMA ownership of the device
> > > > during passthrough.  Refuse CMA reauthentication on the host as long.
> > > > After passthrough has concluded, reauthenticate the device on the host.  
> > > 
> > > Is there anything stopping a PF presenting multiple CMA capable DOE
> > > instances?  I'd expect them to have their own contexts if they do..  
> > 
> > The spec does not seem to *explicitly* forbid a PF having multiple
> > CMA-capable DOE instances, but PCIe r6.1 sec 6.31.3 says:
> > "The instance of DOE used for CMA-SPDM must support ..."
> > 
> > Note the singular ("The instance").  It seems to suggest that the
> > spec authors assumed there's only a single DOE instance for CMA-SPDM.
> 
> It's a little messy and a bit of American vs British English I think.
> If it said
> "The instance of DOE used for a specific CMA-SPDM must support..." 
> then it would clearly allow multiple instances.  However, conversely,
> I don't read that sentence as blocking multiple instances (even though
> I suspect you are right and the author was thinking of there being one).
> 
> > 
> > Could you (as an English native speaker) comment on the clarity of the
> > two sentences "Prevent ... as long." above, as Ilpo objected to them?
> > 
> > The antecedent of "Prevent" is the undesirable behaviour in the preceding
> > sentence (host resets guest's SPDM connection).
> > 
> > The antecedent of "as long" is "during passthrough" in the preceding
> > sentence.
> > 
> > Is that clear and understandable for an English native speaker or
> > should I rephrase?
> 
> Not clear enough to me as it stands.  That "as long" definitely feels
> like there is more to follow it as Ilpo noted.
> 
> Maybe reword as something like 
> 
> Prevent this by letting the guest claim exclusive ownership of the device
> during passthrough ensuring problematic CMA reauthentication by the host
> is blocked.

My contribution to the prose here is to clarify that this mechanism is
less about "appoint the guest as the exslusive owner" and more about
"revoke the bare-metal host as the authentication owner".

In fact I don't see how the guest can ever claim to "own" CMA since
config-space is always emulated to the guest. So the guest will always
be in a situation where it needs to proxy SPDM related operations. The
proxy is either terminated in the host as native SPDM on behalf of the
guest, or further proxied to the platform-TSM.

So let's just clarify that at assignment, host control is revoked, and
the guest is afforded the opportunity to re-establish authentication
either by asking the host re-authenticate on the guest's behalf, or
asking the platform-tsm to authenticate the device on the guest's
behalf.

...and even there the guest does not know if it is accessing a 1:1 VF:PF
device representation, or one VF instance of PF where the PF
authentication answer only occurs once for all potential VFs.

Actually, that brings up a question about when to revoke host
authentication in the VF assignment case? That seems to be a policy
decision that the host needs to make globally for all VFs of a PF. If
the guest is going to opt-in to relying on the host's authentication
decision then the revoking early may not make sense. It may be a
decision that needs to be deferred until the guest makes its intentions
clear, and the host will need to have policy around how to resolve
conflicts between guestA wants "native" and guestB wants "platform-TSM".
If the VFs those guests are using map to the same PF then only one
policy can be in effect.
