Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C314D18000B
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 15:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgCJOXo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 10:23:44 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36232 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgCJOXo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 10:23:44 -0400
Received: by mail-wr1-f68.google.com with SMTP id s5so12213998wrg.3;
        Tue, 10 Mar 2020 07:23:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=M0NhMQmLrSg5FNM5EpjRPkXpDH6fu+ElyPjCQqwOiZM=;
        b=BFLiO57EpWxZlVsVC6uVWpg0Lp5SltIzbyigkHZyX8rFLNAtTRw+j6m17aVHq4yIed
         FU499/BJ0GOLocLi7lmyRAVAzRt0ZYXpq4JYmoNozakwoZFegrqOu4k30Q9L0LuKhLYX
         uBwlzYwvkYFmiJUpvcLyI6RKfa9sEpeHdAMJW2UbBNwBNGz14YHbU+ZZ/iJK1fmreQEh
         IjOssMnFD3usow8X1j+6OwKmoHU5p2gLfZruWE2z0/AgrBdgicWqd5vlyMpEtKrVPcth
         d51++UUFKWgSeTb4f179nLVblHPTjeTjYhoS3QUCsTYt/dSKgyIKa/KW2KQBTdu5CvRj
         RPfQ==
X-Gm-Message-State: ANhLgQ1QScbUOrSWgfZPGRG6tV0aVKwZR90XCBMGy/C+fPP+KLi8qba5
        gIgyk56fppdhV6vbiElLUEs=
X-Google-Smtp-Source: ADFU+vuYOLRLQNnL+N3fFhcD9rSU4FbtIt+12do4NYt7b/JMX894egNubgXrABTNaqXSneJApxpvXA==
X-Received: by 2002:adf:f581:: with SMTP id f1mr14346398wro.38.1583850222186;
        Tue, 10 Mar 2020 07:23:42 -0700 (PDT)
Received: from debian (41.142.6.51.dyn.plus.net. [51.6.142.41])
        by smtp.gmail.com with ESMTPSA id k18sm16402611wru.94.2020.03.10.07.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 07:23:41 -0700 (PDT)
Date:   Tue, 10 Mar 2020 14:23:39 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     Jon Doron <arilou@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v4 2/5] x86/hyper-v: Add synthetic debugger definitions
Message-ID: <20200310142339.27d7hieugd4qu654@debian>
References: <20200309182017.3559534-1-arilou@gmail.com>
 <20200309182017.3559534-3-arilou@gmail.com>
 <DM5PR2101MB104761F98A44ACB77DA5B414D7FE0@DM5PR2101MB1047.namprd21.prod.outlook.com>
 <20200310032453.GC3755153@jondnuc>
 <MW2PR2101MB10522800EB048383C227F556D7FF0@MW2PR2101MB1052.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB10522800EB048383C227F556D7FF0@MW2PR2101MB1052.namprd21.prod.outlook.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 10, 2020 at 03:53:06AM +0000, Michael Kelley wrote:
[...]
> > 
> > In case you end up insisting I'll remove the MSR and CPUID leaf
> > definitions what would be the workaround to implement the syndbg functionality?
> 
> I'm flexible, and trying to not be a pain-in-the-neck. :-)  What would
> the KVM guys think about putting the definitions in a KVM specific
> #include file, and clearly marking them as deprecated, mostly
> undocumented, and used only to support debugging old Windows
> versions?
> 

+1 for this.

Wei.
