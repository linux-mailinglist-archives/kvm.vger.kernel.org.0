Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBB933A487
	for <lists+kvm@lfdr.de>; Sun,  9 Jun 2019 11:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbfFIJiU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Jun 2019 05:38:20 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:42974 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728014AbfFIJiU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Jun 2019 05:38:20 -0400
Received: by mail-wr1-f44.google.com with SMTP id x17so6172376wrl.9
        for <kvm@vger.kernel.org>; Sun, 09 Jun 2019 02:38:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Rl3wdZpdqQKjkaxuOeUhLs7Pd+vggvFN3Rrnjl23mrc=;
        b=QVHzaEBXAfftWjuI/nCjIa7Ofo3huCIVH8nfzefMCrkIknbeqwtQXkhs1Z5gnYKgF3
         Mqb0wxy8aa/7Y7XXWUzk0oeM5AblGXuUEMBbsicC0PX4MEzG+LGrfk9VSXSub5kJHu72
         /tR+JbQl+8Z6fDwd6zcagKj1WDiy9ZzJZpPvJUIV1F1568owHNQ2JtFEF4i461QpqHEj
         sB6j9Qw3pv8SGOYvpiTfHJha5m09SYj9MVEY3Bc9YH7aRec2i/TOvoWaf+kWArgXA52Q
         WUXZBsCfX9UCTGqnvvHk/i59PgZwMDhoVcLmFHa9ssnlMDZg8JgvzXp3epaw2SqmFJH/
         EhhA==
X-Gm-Message-State: APjAAAVecKvXTtf5qcwYCGXXeBVVUCtI26DEslzGUUQm41TZOoo5D/r1
        080hfTvmdf1ZVaz4f/TT1mcyi7WGNm4=
X-Google-Smtp-Source: APXvYqyqsG6n9zfM4whFnbE1Jjf5XqCFxaLMMbAHIw3EXsfDb2wgMC4qT0NCCMX8EOucNaCx53TWyw==
X-Received: by 2002:adf:9cd0:: with SMTP id h16mr24912697wre.211.1560073098493;
        Sun, 09 Jun 2019 02:38:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8cc3:8abd:4519:2cd6? ([2001:b07:6468:f312:8cc3:8abd:4519:2cd6])
        by smtp.gmail.com with ESMTPSA id s8sm11685456wra.55.2019.06.09.02.38.17
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2019 02:38:17 -0700 (PDT)
Subject: Re: [PATCH] nVMX: Get rid of prepare_vmcs02_early_full and inline its
 content in the caller
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com
References: <20190607180544.17241-1-krish.sadhukhan@oracle.com>
 <20190607185224.GI9083@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <144da5ef-9114-91a9-3609-f3c34dcbdd90@redhat.com>
Date:   Sun, 9 Jun 2019 11:38:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190607185224.GI9083@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/06/19 20:52, Sean Christopherson wrote:
> My vote is to keep the separate helper.  I agree that it's a bit
> superfluous, but I really like having symmetry across the "early" and
> "late" prepartion flows, i.e. there's value in having both
> prepare_vmcs02_full() and prepare_vmcs02_early_full().

I agree.

Paolo
