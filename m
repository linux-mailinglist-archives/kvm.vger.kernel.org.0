Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331306DCAD9
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 20:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjDJShg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 14:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjDJShf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 14:37:35 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB7611B;
        Mon, 10 Apr 2023 11:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681151854; x=1712687854;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QmvM0EGnNtLvuWG9UZaSLtWZs08XwLX8LmmtdbI/v10=;
  b=TNjHbJa2NNVzT237Ao89M9eDpS5yK33Rd5fs+v2ZwFgACVNJcE3i/b5r
   NPXxzrgIkCeFYpK8inoxW69pd25wcBTIeEbxAf4x+VKLrCo7+KWeHnM0e
   Sx2Tdmar2c6lPdqLdhKCkBiPotvM5xYFUCLWyBnYEcz5qBZjfh3jofIqm
   ydAzeEFvUX1u2Ywovyd7Rn1MVU7hZxWyX3/nv4Pj1xxfD0lE6cKn7AKMt
   FZKYgwYveTgR64rE6qLIXVwoesnLJZxYb3OSkHz6htfBJ7I+XVA94dW7S
   tjWlJbgcnEiEkXrNGGuF+bSSIBQ5UXDINQiTuoQDauPYA2GbC2vSJEegN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="342191552"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="342191552"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 11:37:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="688349389"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="688349389"
Received: from arsetion-mobl.amr.corp.intel.com (HELO [10.209.122.228]) ([10.209.122.228])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 11:37:19 -0700
Message-ID: <f3b12e7a-3536-c0af-2c67-d94c56b6fcc5@intel.com>
Date:   Mon, 10 Apr 2023 11:37:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v8 00/33] x86: enable FRED for x86-64
Content-Language: en-US
To:     Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com, jiangshanlai@gmail.com,
        shan.kang@intel.com, Andy Lutomirski <luto@kernel.org>
References: <20230410081438.1750-1-xin3.li@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230410081438.1750-1-xin3.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/10/23 01:14, Xin Li wrote:
> This patch set enables FRED for x86-64.

I'm worried we're just in a patchbomb-once-a-week mode with FRED at this
point.  There wasn't a single comment on v7 so, of course, here's v8 a
week later.

FRED is a rare CPU feature because it's universally wanted.  Us software
folks have been begging for it for a looooooooong time.  Is there anyone
out there that has any doubts that the kernel will support (this) FRED
eventually?

The code also looks pretty reasonable.

I do think it's missing some Documentation, and the cover letter is bit
sparse.  It would be nice to see some high-level information about
things like, for instance, why there needs to be FRED refactoring for
NMI/#PF/#DB/#MC specifically, but not other exceptions.

There also aren't any new selftests.  I faintly recall some tweak to the
selftests recently that was FRED-oriented, but I'd still expect all the
selftests that poke at the entry code to be perturbed by this a bit.

Basically, if anyone else has been procrastinating on reviewing this
set, now is probably the time to dig in.  (I'll include myself in that
category, btw)
