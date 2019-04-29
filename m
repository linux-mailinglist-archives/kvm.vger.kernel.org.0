Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A779FE477
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2019 16:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbfD2OQj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Apr 2019 10:16:39 -0400
Received: from mga05.intel.com ([192.55.52.43]:64137 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728258AbfD2OQi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Apr 2019 10:16:38 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 07:16:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,409,1549958400"; 
   d="scan'208";a="154733513"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by orsmga002.jf.intel.com with ESMTP; 29 Apr 2019 07:16:36 -0700
Date:   Mon, 29 Apr 2019 07:16:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Simon Becherer <simon@becherer.de>,
        Iakov Karpov <srid@rkmail.ru>,
        Gabriele Balducci <balducci@units.it>,
        Antti Antinoja <reader@fennosys.fi>,
        Takashi Iwai <tiwai@suse.com>, Jiri Slaby <jslaby@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] KVM: x86: Whitelist port 0x7e for pre-incrementing %rip
Message-ID: <20190429141637.GA31379@linux.intel.com>
References: <20190426233846.3675-1-sean.j.christopherson@intel.com>
 <496631087.15675835.1556338763312.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496631087.15675835.1556338763312.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 27, 2019 at 12:19:23AM -0400, Paolo Bonzini wrote:
> The patch should probably be tweaked to use the quirks mechanism.  I'll post
> an adjusted version next Monday.

I took the liberty of posting v2 since it's a trivial change.
