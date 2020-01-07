Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7B513277C
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 14:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgAGNWg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 08:22:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24102 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727559AbgAGNWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 08:22:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578403354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=LNUT/hHhL/0bCvA6gx6KaFh2+LrEB/0tku2uCC8cN1Q=;
        b=Z3EkAwa5Vj9u3HOjnRcc/V/4JrkZkPmZUF67R6vmPliq4PnEDIhPyFJzXRNuiWYNPMLeJE
        GOsyZU6rgqTgKz82+GULfTDSLC7P5FJoTC7gobxMpquZjeZSxTPJTUiFAMaKuA1cVt77DO
        gMAXCE2cjbUx+ztgai+bAlCEkjAziPw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-gaacI1x4Og6D9MzfxpUz6Q-1; Tue, 07 Jan 2020 08:22:31 -0500
X-MC-Unique: gaacI1x4Og6D9MzfxpUz6Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61E0E107ACC5;
        Tue,  7 Jan 2020 13:22:30 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-116.ams2.redhat.com [10.36.116.116])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 52A2A7C015;
        Tue,  7 Jan 2020 13:22:29 +0000 (UTC)
Subject: Re: [kvm-unit-tests] ./run_tests.sh error?
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>,
        Haiwei Li <lihaiwei.kernel@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <46d9112f-1520-0d81-e109-015b7962b1a7@gmail.com>
 <20191227124619.5kbs5l7gooei6lgp@kamzik.brq.redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <8e25eae1-1a80-ddb7-9085-5ba0d8b515cc@redhat.com>
Date:   Tue, 7 Jan 2020 14:22:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191227124619.5kbs5l7gooei6lgp@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/12/2019 13.46, Andrew Jones wrote:
> On Wed, Dec 25, 2019 at 01:38:53PM +0800, Haiwei Li wrote:
>> When i run ./run_tests.sh, i get output like this:
>>
>> SKIP apic-split (qemu: could not open kernel file '_NO_FILE_4Uhere_': No
>> such file or directory)
>> SKIP ioapic-split (qemu: could not open kernel file '_NO_FILE_4Uhere_': No
>> such file or directory)
>> SKIP apic (qemu: could not open kernel file '_NO_FILE_4Uhere_': No such file
>> or directory)
>> ......
[...]
> You need https://patchwork.kernel.org/patch/11284587/ for this issue.
 Hi Paolo,

could you maybe apply my patch directly, to avoid that other people run
into this issue, too?

 Thanks,
  Thomas

