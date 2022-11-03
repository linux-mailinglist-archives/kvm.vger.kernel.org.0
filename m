Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84906617456
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 03:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiKCCkK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 22:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiKCCkI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 22:40:08 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DB3DE87
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 19:40:06 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id A09DC5C01BD;
        Wed,  2 Nov 2022 22:40:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 02 Nov 2022 22:40:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
         h=cc:cc:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1667443204; x=1667529604; bh=cD
        NESOhKDhjaMcBdNSjSfhaiKZw4wV32OXyCOuA+q5c=; b=dGf4E9y70XWB6vESrM
        4uLHLQzuWJfHVDFPIY5ods3jHYuZRoZ6i60RbxsYKVMd0f3hnNy1AslJeT/DNYKL
        2pNb+Y5MKl1TYWza7wZ00wLKsyNVkMrO8kNoxQUHqpv4odV416DHJyRQGsYBgL0v
        GKoZzp80OKLWVKjjaXyGm2OQ7a9WpFPFrmuZ5SdIOs4F5baiOtX0xaJl94TzUYEv
        QpidXORnYZlQ+AMRKCpLJBCw8KBpWXu+OfNp9m2C5umrcrlXCJLcTtKPahIK4jAM
        L4p2jfFQZoCvZ+K/74XiBJmGVlEObeL9ik+ggaVGh4TsLb7VvnVTuC3gKNaMIjOY
        B/DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1667443204; x=1667529604; bh=cDNESOhKDhjaMcBdNSjSfhaiKZw4
        wV32OXyCOuA+q5c=; b=ZsNUiAP5XuI1rfVWYaXdDprCuV1Vd5a30mZAfpcUbLVY
        cGKSY4HY13t0IetSXcoh4L0IS4SLTGdSsA4GfP4O6mIBpRNnQaCAhMcIxRSjzdsl
        N9z7DuJUxrsVP1bV6kvr+Q3RCqv9ewUZ5umsij26ltXuAEMOtFcd3gXHLoT8Wk7Z
        5jzg4Avny1msF90XYWHZ8me411Mwjijs0YdpGYbkrWL4Yr8ptJcorccUK8fzQi62
        tb1q91ROl2W9m9Q3ERLFMLTY4h4kHchC9pey6JL3SGYXLVKrOpHGehOBWS3wLG9j
        uPtW9zsyq0RdsaMJsEmmTNOuvMZjdhLnOFUiFUTNsw==
X-ME-Sender: <xms:BCpjY-OlyGZ7aui2G0Tmh6dUFv9JeE6mkJBY6Qop9tnElMnWwHn2WQ>
    <xme:BCpjY8-vshdezlvq7DLjmaRkQDosUS3pEyG2C99Fouf4BScsWhHOvdiDXm6fmtsm-
    Nc-u_4LQ1MgJ4tLCy0>
X-ME-Received: <xmr:BCpjY1QtPS0uANcQ8UipScLWMJPs-MAUvFbPCWWBK59OBw1JHBcMz4yTm1OotfHjg06MtA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrudekgdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggujgesthdttd
    dttddtvdenucfhrhhomhepfdfmihhrihhllhcutedrucfuhhhuthgvmhhovhdfuceokhhi
    rhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrghtthgvrhhnpefhieeghf
    dtfeehtdeftdehgfehuddtvdeuheettddtheejueekjeegueeivdektdenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuh
    htvghmohhvrdhnrghmvg
X-ME-Proxy: <xmx:BCpjY-swGSA0PwLsFW39jsBtkm4kueOyj4x9ZNUO9Oq8Udltz54TlQ>
    <xmx:BCpjY2e6lGtUPsz1BL6kUTKhBhsRDgGAow2OFZk-N3kuwnwcFVF2pw>
    <xmx:BCpjYy2EphcwNfzQ0vh_ZWLIaN5z_vgO_2HFsnV1OBG5iRp6vMPbbA>
    <xmx:BCpjY3oNoOR4T0HZcj8ARDAbB-AxM_fQ5pGwPQ05U_TN-sXaj_CiNg>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 2 Nov 2022 22:40:04 -0400 (EDT)
Received: by box.shutemov.name (Postfix, from userid 1000)
        id C238310445C; Thu,  3 Nov 2022 05:40:01 +0300 (+03)
Date:   Thu, 3 Nov 2022 05:40:01 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH 8/9] KVM: x86: When guest set CR3, handle LAM bits
 semantics
Message-ID: <20221103024001.wtrj77ekycleq4vc@box.shutemov.name>
References: <20221017070450.23031-1-robert.hu@linux.intel.com>
 <20221017070450.23031-9-robert.hu@linux.intel.com>
 <20221031025930.maz3g5npks7boixl@box.shutemov.name>
 <d03bcd8fe216e5934473759fa6fdaac4e1105847.camel@linux.intel.com>
 <20221101020416.yh53bvpt3v5gwvcj@box.shutemov.name>
 <1d6a68dd95e13ce36b9f3ccee0b4e203a3aecf02.camel@linux.intel.com>
 <20221102210512.aadxeb3qiloff7yl@box.shutemov.name>
 <9578f16e8be3dddae2c5571a4a8f033ab4259840.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9578f16e8be3dddae2c5571a4a8f033ab4259840.camel@linux.intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 03, 2022 at 09:04:23AM +0800, Robert Hoo wrote:
> I also notice that skip_tlb_flush is set when pcid_enabled && (CR3
> & X86_CR3_PCID_NOFLUSH). Under this condition, do you think (0,0) -->
> (1,0) need to flip it back to false?

Yes, I think we should. We know it is a safe choice.

It also would be nice to get LAM documentation updated on the expected
behaviour. It is not clear from current documentation if enabling LAM
causes flush. We can only guess that it should at least for some
scenarios.

Phantom TLB entires that resurface after LAM gets disable would be fun to
debug.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
