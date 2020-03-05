Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5D5917AAEA
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 17:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgCEQvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 11:51:38 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:28523 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725944AbgCEQvi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Mar 2020 11:51:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583427097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SqVNCIytxdHmAm4l+2tk3rB1xbxHOZa0mRnp6D7J+Ck=;
        b=XLoJqbnxBCuJWDevZV/i5gn8osNlyTHyVJNfdQQ2MryiU9bETxDNM6oYBKrMNPHzyTY5bp
        4OOs0cJWV7IBMUhPUXigsHpqXTfPy39xmNfuFB3w+sdzFtq3x0kadxI2K/FmsjWqa0+2RL
        O52huwxiRsE6Pp1IbMxOH04MSCcEW9o=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-5iL60ZXyO2eV5bvF4SDGxQ-1; Thu, 05 Mar 2020 11:51:32 -0500
X-MC-Unique: 5iL60ZXyO2eV5bvF4SDGxQ-1
Received: by mail-wm1-f70.google.com with SMTP id p17so971116wmc.9
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 08:51:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SqVNCIytxdHmAm4l+2tk3rB1xbxHOZa0mRnp6D7J+Ck=;
        b=RJ5jZIAV9aByv9RDx8NPH70xnf4G394S1kjm112L58XugZQN+RKqOsV8kw9SMIR//X
         jKYEM4BqZxHmZq0QzTjljyfV6IgpMYuqB44oyZ3FlXhU68M5yLhB3XLayNll4AhYzEWM
         tLRrbnfCv3xfL5r8cYrQObE7VjzIFSxgQFid8HxAQYRvwIeD6/FWKALVULcf6M7RQFre
         hnrFeGAXGiHa5e3BJ1iJB+2VAYwWSiALhVZb+bOTzfmUxrnP+z3jCEXLKLUffi3mpWzP
         pt53LkeMlnU9G8R7e+sXjfQMNRxKNdOi5eYoSDwVIK7c3v78D0afKWOhmnaEkppgLBp+
         0eMg==
X-Gm-Message-State: ANhLgQ3I1bsrgYFdYnrLcyFlFEMGe9gLGS2C7ZuHhiYWYEYS+W+Gj4VZ
        r24leK7hqa7qscWm1L+a3JRm9wXCr0zPgLl41avj11ejG4S/qztE69TMr0nnX+JN0CLL4i2fg02
        QLA7p88l70rbH
X-Received: by 2002:a7b:c446:: with SMTP id l6mr10060473wmi.3.1583427091590;
        Thu, 05 Mar 2020 08:51:31 -0800 (PST)
X-Google-Smtp-Source: ADFU+vty5v9FoOa0gGl9gu7HAojv2CNgZGjeX+xuelU6nsEMG9+BrIhKp6yHt4D+lPtraLEsiIFV/w==
X-Received: by 2002:a7b:c446:: with SMTP id l6mr10060406wmi.3.1583427090476;
        Thu, 05 Mar 2020 08:51:30 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:9def:34a0:b68d:9993? ([2001:b07:6468:f312:9def:34a0:b68d:9993])
        by smtp.gmail.com with ESMTPSA id e1sm32448187wrx.90.2020.03.05.08.51.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 08:51:29 -0800 (PST)
Subject: Re: [PATCH v1 00/11] PEBS virtualization enabling via DS
To:     Luwei Kang <luwei.kang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@redhat.com, namhyung@kernel.org, tglx@linutronix.de,
        bp@alien8.de, hpa@zytor.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, pawan.kumar.gupta@linux.intel.com,
        ak@linux.intel.com, thomas.lendacky@amd.com, fenghua.yu@intel.com,
        kan.liang@linux.intel.com, like.xu@linux.intel.com
References: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <da7e4734-a184-7f4f-6456-e57ac6d8063d@redhat.com>
Date:   Thu, 5 Mar 2020 17:51:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/03/20 18:56, Luwei Kang wrote:
> BTW:
> The PEBS virtualization via Intel PT patchset V1 has been posted out and the
> later version will base on this patchset.
> https://lkml.kernel.org/r/1572217877-26484-1-git-send-email-luwei.kang@intel.com/

Thanks, I'll review both.

Paolo

