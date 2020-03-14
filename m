Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C558C1859E0
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 04:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbgCODwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Mar 2020 23:52:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48115 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727527AbgCODwX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Mar 2020 23:52:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584244342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cams43BRaSryQXKzOLgz59jXTIRFKFLmhG2spAnZE4k=;
        b=Ew4pGiu73ujSUP8O4RXkcbMTrCE7wNBidJCixw8QKtYczc5H52ZGckeGsoG4MJPHvFw5eY
        oVQqZyyk0mWRlqzT5BjTvn6Qgg9jEAe2jO6KkopaL9cGDHeF3VkvqfOfBRAy45/S/A6RDF
        t85xcyrd6649Cn+hlp0JEG+ct1aCyQM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-dVOg45iyPOmAhm5vPkeSgQ-1; Sat, 14 Mar 2020 07:48:04 -0400
X-MC-Unique: dVOg45iyPOmAhm5vPkeSgQ-1
Received: by mail-wr1-f72.google.com with SMTP id 94so1151297wrr.3
        for <kvm@vger.kernel.org>; Sat, 14 Mar 2020 04:48:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cams43BRaSryQXKzOLgz59jXTIRFKFLmhG2spAnZE4k=;
        b=h8dl1SI0PSAK/XHh2mT7g8mtBLYEOuH8z1HKaRi1yJMW0Jkxpzf87bjI6a7l8i/TIx
         CIY7VmdiWkx8q/VXxmxy8SF9Zks0QpVeOCI33ijLW73hX4dEan7b+CbXWRdU4+d0j0n+
         f4Of4ov85YlNNZzZuSezylj/eu3kLJJ7mLik2NMZn9Ki7ygJG4E2Hxz0DftbdB6OIOTt
         PPX3YC0GNk2rZ7tom5t5/foLxSSSdijqShwfnBC2dabHjqvjOpZJYyFUKkjUsQaURfkF
         KOjT7UjwpYZj20IsmkZFjmJXi+/QVsr/T4TYvdJVh+UmcSCWRBUh2Ru+lAPsDdUYY+LU
         +FVQ==
X-Gm-Message-State: ANhLgQ1so0k1Emu8GfP1nFdOFA9FESH3/KLtPoCtF8mtp/jkEqJHRk3Z
        /SiprMbjxZ2qPWlCvrj1552vNJalQfPEtxksiZ1jRwIfqP8PHuwEPZDSQbm5NEpK0flk6Yi0L0s
        AEhMtr92qajMI
X-Received: by 2002:adf:82ee:: with SMTP id 101mr23493126wrc.7.1584186483718;
        Sat, 14 Mar 2020 04:48:03 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vv/exKCAnUJBy9dNlX2Ewgz1LAYenF4P9VYNNHkRNx1Cwdkk6TKpo/sMt98U/CeHR8RncElrQ==
X-Received: by 2002:adf:82ee:: with SMTP id 101mr23493112wrc.7.1584186483449;
        Sat, 14 Mar 2020 04:48:03 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.174.5])
        by smtp.gmail.com with ESMTPSA id w4sm32809119wrl.12.2020.03.14.04.48.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Mar 2020 04:48:02 -0700 (PDT)
Subject: Re: [PATCH 0/5] selftests: KVM: s390: Accumulated fixes and
 extensions
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <20200310130144.9921-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8d09a198-ba35-1591-6a79-57f336e2f1c5@redhat.com>
Date:   Sat, 14 Mar 2020 12:48:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200310130144.9921-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/03/20 14:01, Christian Borntraeger wrote:
> - do more and better testing for reset
> - fix fprintf formats (thanks to Andrew Jones)
> 
> Paolo, I would schedule this for next and not for master. ok?
> 
> Christian Borntraeger (5):
>   selftests: KVM: s390: fix early guest crash
>   selftests: KVM: s390: test more register variants for the reset ioctl
>   selftests: KVM: s390: check for registers to NOT change on reset
>   selftests: KVM: s390: fixup fprintf format error in reset.c
>   selftests: KVM: s390: fix format strings for access reg test
> 
>  tools/testing/selftests/kvm/s390x/resets.c    | 132 ++++++++++++++----
>  .../selftests/kvm/s390x/sync_regs_test.c      |  11 +-
>  2 files changed, 116 insertions(+), 27 deletions(-)
> 

Queued, thanks.  I pulled the format strings fixes before -Wformat is
enabled.

Paolo

