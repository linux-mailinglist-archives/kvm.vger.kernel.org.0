Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4094118C7
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 18:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236609AbhITQB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 12:01:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54370 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231770AbhITQB4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 12:01:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632153629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/mUAEG3/Zyx+LoPhPJ8bEPbOJOvIOT0iUS/M6XNysYc=;
        b=Lxz3wTYNRhrSCv4lQYuIkWpukVSA4MaJTtspKz3PKf5OX5qwSw74OR9HUUiXiLSqIU6MeD
        bFZQjsYkgCeF+7EobzbcOjsWJVdzo3MJPT5YsYySX5wEnoUCiYVHFsSd7H1XfvG4reC5A1
        WnpC+a0+xzRA7Sxk7XRCWnZjAm2OEBQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-4T7NZt5ZO7qYyj-JrGxapw-1; Mon, 20 Sep 2021 12:00:28 -0400
X-MC-Unique: 4T7NZt5ZO7qYyj-JrGxapw-1
Received: by mail-ed1-f69.google.com with SMTP id j6-20020aa7de86000000b003d4ddaf2bf9so16080716edv.7
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 09:00:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/mUAEG3/Zyx+LoPhPJ8bEPbOJOvIOT0iUS/M6XNysYc=;
        b=ZQjiijGt+FU5S7zpxujOStWHAAAyTNXdTvg+NoGUgM7ftKbuP9FbxKoB/WNGCOmxhY
         XQQmM2E1oD9kG0w3skv+Td6kRsW/scUPR7i35zu3FoZq6CIK1yCbXD8kXXruGJZmV0OY
         uGEBIUOMLSceHPcudsEVD/WrFfY+AltdWLRntbkzlf6GU2UyS9cpjoPxD5tm4bpD937t
         cXVmUyE6+ZqNiv8VnGKmP5WhhRZd7ZQaPZKTqqTP5CjTR6RR9r0Ylajj2DfWByPUy+vl
         h0VkFFmWIy2lSiNdVkZi2AHlnu3RZbZD1/WOU+e4OxMr4UQEjGmHUwLfwgrl7JGtE31Z
         QZOg==
X-Gm-Message-State: AOAM530A9GuyK6Al+cp6MDyjawTeyF9KhwR5tmiC0LcUvkTdXKpYAsdV
        gnh3eq6Ke9QT2iqQyLy4Db/67shhIp9sjBHaPDdzBbP1pXwIUV5lRfTYO97tvukXLO38nGeAQ0S
        vrDkY6P5EzRuS
X-Received: by 2002:a50:c949:: with SMTP id p9mr30384443edh.326.1632153626558;
        Mon, 20 Sep 2021 09:00:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJws9T17EII7HneSbh4vp1OHAfNCrt3yNUYClmwn0ioBeM6nfEubraJCuopvqhL570FUXQ0OqQ==
X-Received: by 2002:a50:c949:: with SMTP id p9mr30384400edh.326.1632153626347;
        Mon, 20 Sep 2021 09:00:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g1sm2618942edv.25.2021.09.20.09.00.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 09:00:25 -0700 (PDT)
To:     Zixuan Wang <zixuanwang@google.com>, kvm@vger.kernel.org,
        drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
References: <20210827031222.2778522-1-zixuanwang@google.com>
 <20210827031222.2778522-15-zixuanwang@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 14/17] x86 AMD SEV-ES: Load GDT with
 UEFI segments
Message-ID: <34173c4c-d704-5d28-8aac-c2debf224a86@redhat.com>
Date:   Mon, 20 Sep 2021 18:00:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210827031222.2778522-15-zixuanwang@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/21 05:12, Zixuan Wang wrote:
> + *
> + * This is because KVM-Unit-Tests reuses UEFI #VC handler that requires UEFI
> + * code and data segments to run. The UEFI #VC handler crashes the guest VM if
> + * these segments are not available. So we need to copy these two UEFI segments
> + * into KVM-Unit-Tests GDT.
> + *
> + * UEFI uses 0x30 as code segment and 0x38 as data segment. Fortunately, these
> + * segments can be safely overridden in KVM-Unit-Tests as they are used as
> + * protected mode and real mode segments (see x86/efi/efistart64.S for more
> + * details), which are not used in EFI set up process.

Is 0x30/0x38 the same as kvm-unit-tests's 0x08/0x10?  Can kvm-unit-tests
simply change its ring-0 64-bit CS/DS to 0x30 and 0x38 instead of 0x08
and 0x10?  I can help with that too, since there would be some more
shuffling to keep similar descriptors together:

  * 0x00         NULL descriptor               NULL descriptor
  * 0x08         intr_alt_stack TSS            ring-0 code segment (32-bit)
  * 0x10 (0x13)  **unused**                    ring-3 code segment (64-bit)
  * 0x18         ring-0 code segment (P=0)     ring-0 code segment (64-bit, P=0)
  * 0x20         ring-0 code segment (16-bit)  same
  * 0x28         ring-0 data segment (16-bit)  same
  * 0x30         ring-0 code segment (32-bit)  ring-0 code segment (64-bit)
  * 0x38         ring-0 data segment (32-bit)  ring-0 data segment (32/64-bit)
  * 0x40 (0x43)  ring-3 code segment (32-bit)  same
  * 0x48 (0x4b)  ring-3 data segment (32-bit)  ring-3 data segment (32/64-bit)
  * 0x50-0x78    free to use for test cases    same

or:

old	new
----	----
0x00	0x00
0x20	0x08
0x48	0x10
0x18	0x18
0x28	0x20
0x30	0x28
0x08	0x30
0x10	0x38
0x38	0x40
0x40	0x48

Thanks,

Paolo

