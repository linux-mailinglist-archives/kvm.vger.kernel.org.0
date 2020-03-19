Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3364918B833
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 14:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgCSNir (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 09:38:47 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:40639 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727386AbgCSNF3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Mar 2020 09:05:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584623128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h7iXFnc3rkjcIjxB0MRXLtgPjHPc/GETaaRu2YfWDZY=;
        b=LkgyS+FpTtW7wjX9lGYUNMZ3621GLMZ8JaOQBz7Ejr+w2NG3uK2IQUv3ifTBP02M2/du17
        zyOBLFQm+yNyOClhYoDbuzaK5U3E26otAZMG6HaPa3H0heMYj3gUqufbFvedJTN0DsJ99q
        E/pioGtzit9wPWhe9qmwBSAwILwcoEU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-ldL48Rv_Og-5um3fzvJOyg-1; Thu, 19 Mar 2020 09:05:26 -0400
X-MC-Unique: ldL48Rv_Og-5um3fzvJOyg-1
Received: by mail-wr1-f71.google.com with SMTP id d17so969762wrs.7
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 06:05:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h7iXFnc3rkjcIjxB0MRXLtgPjHPc/GETaaRu2YfWDZY=;
        b=m9Qiqj9iYHEO22g2aCMaXx+tclmiSAW+XipNvzC2OAe4BNprdv/lo3Kyikl2EaSmP8
         N/I8ZktycTYGG6YNSstWnmTKYkR+Ntt/Q7FLDYBtQjjHrf9wf5ry6Sxz8FWO2G/+sTWz
         sxN2zN9+LSHOj4BVl5PtfzQcPDJzFqT6MYnObTu6H3g9yNBJV2HH9+9fM+5WIk/nxza3
         JxaMFBTPQgCi451/TpkWGs93k+6Zv2acoQPQsQbHDfnPFisRa/2XkiupK5GR0ONyxt5U
         wnBysTCeQXwz8suRwuMKdCOxtcopavmTwvDnzViUkPLsZU5uGgAoYvCreaMIE5kKwwIt
         VZYw==
X-Gm-Message-State: ANhLgQ2QzEOlq3SOnDK+IBwZzaAo8dC5C1o3h6eZahp9MhNplpFz24Ji
        Y32II9ml7Ecm+fTlLji0aiyNUVy7oRbI7V1bib00Bo9XT76fTmctGbXw+F4B8UOA8RMbveFXzTB
        8dMeSNyOrvY00
X-Received: by 2002:adf:e9d2:: with SMTP id l18mr4141025wrn.400.1584623125148;
        Thu, 19 Mar 2020 06:05:25 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvUeEF4lWmB6DnjFfzKFDT4amKFY8lP/2zFH/xeioNvGBfVaVwTGmv399gN3+BdRl6h8oOzCQ==
X-Received: by 2002:adf:e9d2:: with SMTP id l18mr4140997wrn.400.1584623124901;
        Thu, 19 Mar 2020 06:05:24 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.43])
        by smtp.gmail.com with ESMTPSA id n2sm3254478wrr.62.2020.03.19.06.05.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2020 06:05:24 -0700 (PDT)
Subject: Re: [PATCH 00/12] SEV Live Migration Patchset.
To:     Ashish Kalra <ashish.kalra@amd.com>,
        Andy Lutomirski <luto@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1581555616.git.ashish.kalra@amd.com>
 <CALCETrXE9cWd3TbBZMsAwmSwWpDYFsicLZ=amHLWsvE0burQSw@mail.gmail.com>
 <20200213230916.GB8784@ashkalra_ubuntu_server>
 <CALCETrUQBsof3fMf-Dj7RDJJ9GDdVGNOML_ZyeSmJtcp_LhdPQ@mail.gmail.com>
 <20200217194959.GA14833@ashkalra_ubuntu_server>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <101d137c-724a-2b79-f865-e7af8135ca86@redhat.com>
Date:   Thu, 19 Mar 2020 14:05:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200217194959.GA14833@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/02/20 20:49, Ashish Kalra wrote:
>> Also, you're making guest-side and host-side changes.  What ensures
>> that you don't try to migrate a guest that doesn't support the
>> hypercall for encryption state tracking?
> This is a good question and it is still an open-ended question. There
> are two possibilities here: guest does not have any unencrypted pages
> (for e.g booting 32-bit) and so it does not make any hypercalls, and 
> the other possibility is that the guest does not have support for
> the newer hypercall.
> 
> In the first case, all the guest pages are then assumed to be 
> encrypted and live migration happens as such.
> 
> For the second case, we have been discussing this internally,
> and one option is to extend the KVM capabilites/feature bits to check for this ?

You could extend the hypercall to completely block live migration (e.g.
a0=a1=~0, a2=0 to unblock or 1 to block).  The KVM_GET_PAGE_ENC_BITMAP
ioctl can also return the blocked/unblocked state.

Paolo

