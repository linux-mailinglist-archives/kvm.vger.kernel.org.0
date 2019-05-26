Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC36A2A98F
	for <lists+kvm@lfdr.de>; Sun, 26 May 2019 14:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbfEZMLc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 May 2019 08:11:32 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:40201 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfEZMLc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 May 2019 08:11:32 -0400
Received: by mail-qk1-f195.google.com with SMTP id c70so42285qkg.7
        for <kvm@vger.kernel.org>; Sun, 26 May 2019 05:11:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=17m5qjRn+gOfPG5zvtspmQjNxo1PZa0JwIq69Rsd7PQ=;
        b=S9NvMmZ26qDjO1nXDZ/HBLWF/nDHMOnLUBLAVH6Niy41CfjSatB7keJFiKPZF0X5DD
         1LRxrFAFVvp+KXLEQEVM/4SV3UOonprEN5RELznSuAGzNKabaRrNE9cxR/HZ8XNZyhqd
         4tEamCzcIAbInIY8/JrlzCTjJKE7jNEkCSHJE0Q7K6qTDBnqk+W9+XacoKEDo5flr+gs
         v4caY79pxViiQtg0QB0H0gaXYHZ42c8kEY1CU25DqzIP7CuLTJrIxoANEi9K2CWx7V+4
         WRZZX8IqwfUOiXRitm9JQ2wt1VdZn+9ekm1i5r6OyVgSTKcXNJwTy8yhCU2gjKIe4gGg
         I4Wg==
X-Gm-Message-State: APjAAAU5zmRvILG/Au0156KD0TCUGJp2gjHonhBcbVglhDCrZ9Bf/xmv
        GsbQ1ufnXs0vat43tVWB9YDuLPSRVLk=
X-Google-Smtp-Source: APXvYqwjs+R7LMkDhXD4K/nOaxTe/sfIGqTD/pTYRlTgVDDA/HPNI7iCUlExoUSjZ3O9Xf/Wr6J6Cg==
X-Received: by 2002:a37:4a17:: with SMTP id x23mr33832549qka.206.1558872691099;
        Sun, 26 May 2019 05:11:31 -0700 (PDT)
Received: from knox.orion (modemcable053.167-176-173.mc.videotron.ca. [173.176.167.53])
        by smtp.gmail.com with ESMTPSA id l3sm3143112qkd.49.2019.05.26.05.11.30
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 May 2019 05:11:30 -0700 (PDT)
Subject: Re: [Bug 203543] Starting with kernel 5.1.0-rc6, kvm_intel can no
 longer be loaded in nested kvm/guests
To:     bugzilla-daemon@bugzilla.kernel.org, kvm@vger.kernel.org
References: <bug-203543-28872@https.bugzilla.kernel.org/>
 <bug-203543-28872-ed5vVVKp3S@https.bugzilla.kernel.org/>
From:   David Hill <dhill@redhat.com>
Message-ID: <4d4ebee2-7103-cb23-6adb-b52d5e71cd5e@redhat.com>
Date:   Sun, 26 May 2019 08:11:28 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <bug-203543-28872-ed5vVVKp3S@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

You are right actually.   I did a mistake in my code and it didn't pull 
v5.2-rc1 ... I was still on v5.1.x tag so that's why it didn't work.

I guess this is issue is solved and if I hit any bugs with v5.2-rc1 it'd 
be a new issue since we reverted that commit.

On 2019-05-21 2:06 p.m., bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=203543
>
> --- Comment #14 from Sean Christopherson (sean.j.christopherson@intel.com) ---
> I've verified reverting f93f7ede087f and e51bfdb68725 yields the exact same
> code as v5.2-rc1.  Can you please sanity check that v5.2-rc1 is indeed broken?
> E.g. ensure there are no modified files when compiling and include the git
> commit id in the kernel name.
>
