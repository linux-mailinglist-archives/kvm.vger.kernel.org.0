Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA521C6713
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 06:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725821AbgEFEte (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 00:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgEFEtd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 00:49:33 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D71C061A0F;
        Tue,  5 May 2020 21:49:33 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id k1so520212wrx.4;
        Tue, 05 May 2020 21:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wfKY4GkIahR7CykH5E5LZ7evKcIEeSBnuPWwKOPjFUM=;
        b=bdoxXRYgoq1jfayeYIm43J9z2YvPN2PkInHz4whglgs399FK0lZEK3sfp8hc0KpFeD
         ymY22JmUnkor3AbyExSywergBiqjQcXlc+EPDvBveImUsnG2rWklaAcWjCkRk4LERzFS
         q27JQWf99XHPu+5GCNhyIKIKe6aXDFBkS6WFx4mBSHL717q4KuqHHFVTSTrSuLP3fdtg
         5tvMMZpJB2v5SSWxBCjAuRsxf/m9bCmq3kYDxzeNuPK5Xiydv/c8I/HB1DTk3IaTiGqW
         /g/DLNVxBxMV/S5eIKXJ5uRqvW7KWhat9m05fePiIREw9DOugWLeeb68nVn+LA9HIN5G
         srcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wfKY4GkIahR7CykH5E5LZ7evKcIEeSBnuPWwKOPjFUM=;
        b=lq5B42rIPaAxQO6iBfR9sAywNY+CDgSK+k4nTKGNV9Gox4KhX7bFoXBiloc8U1vrD4
         7aPCqRyDo9ChkiabdDdEGHO0gEpRHNu43Irc/J3TXqSvpMCDz6RM95t7N7P/5rW3aQw4
         2fG0Yu5wJIZoCif9M37imdhccjYoNnE0o/gyQg2CZO0+J3NvYt+tarGKg3Nac8fQyzHj
         JcDwWk2ftm3YoJjT8KzfYU//t51c7LjBoGkAKL6hwaKdm+KE2shfEeHzO2wdRS0PRzMt
         ycAhMEDefAEs40WE3dTRXIXK/vBawK/tTKhIT6Y274t4FSiw15PLoGut7LJyBTfXYXpY
         GIPQ==
X-Gm-Message-State: AGi0PuYZWrEKbzdKhW50vs1ntfNXzFhzM1TJQjqn6/KKpSaMIT7QEl3e
        564B96Mf5wc8dXOJ/0WZ7vc=
X-Google-Smtp-Source: APiQypLsIIVkQapdMZPA6joPwy7NuXaxV16GHg4q5ZFNmX8IByECIO1iOWXn03gtkNtSc25p7q66Fw==
X-Received: by 2002:adf:f38c:: with SMTP id m12mr7026307wro.167.1588740572047;
        Tue, 05 May 2020 21:49:32 -0700 (PDT)
Received: from jondnuc (IGLD-84-229-154-20.inter.net.il. [84.229.154.20])
        by smtp.gmail.com with ESMTPSA id x5sm689439wro.12.2020.05.05.21.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 21:49:31 -0700 (PDT)
Date:   Wed, 6 May 2020 07:49:29 +0300
From:   Jon Doron <arilou@gmail.com>
To:     Roman Kagan <rvkagan@yandex-team.ru>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v2 0/1] x86/kvm/hyper-v: Add support to SYNIC exit on EOM
Message-ID: <20200506044929.GD2862@jondnuc>
References: <20200416125430.GL7606@jondnuc>
 <20200417104251.GA3009@rvkaganb>
 <20200418064127.GB1917435@jondnuc>
 <20200424133742.GA2439920@rvkaganb>
 <20200425061637.GF1917435@jondnuc>
 <20200503191900.GA389956@rvkaganb>
 <87a72nelup.fsf@vitty.brq.redhat.com>
 <20200505080158.GA400685@rvkaganb>
 <20200505103821.GB2862@jondnuc>
 <20200505200010.GB400685@rvkaganb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200505200010.GB400685@rvkaganb>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/2020, Roman Kagan wrote:
>On Tue, May 05, 2020 at 01:38:21PM +0300, Jon Doron wrote:
>> On 05/05/2020, Roman Kagan wrote:
>> > On Mon, May 04, 2020 at 05:55:10PM +0200, Vitaly Kuznetsov wrote:
>> > > and it seems the default state of HV_X64_MSR_SCONTROL is '1', we should
>> > > probably do the same.
>> >
>> > This is the state the OS sees, after the firmware.  You'd see the same
>> > with QEMU/KVM if you used Hyper-V-aware SeaBIOS or OVMF.
>> >
>> > > Is there any reason to *not* do this in KVM when
>> > > KVM_CAP_HYPERV_SYNIC[,2] is enabled?
>> >
>> > Yes there is: quoting Hyper-V TLFS v6.0 11.8.1:
>> >
>> >  At virtual processor creation time and upon processor reset, the value
>> >  of this SCONTROL (SynIC control register) is 0x0000000000000000. Thus,
>> >  message queuing and event flag notifications will be disabled.
>> >
>> > And, even if we decide to violate the spec it's better done in
>> > userspace, loading the initial value and adjusting the synic state at
>> > vcpu reset.
>> >
>> > However leaving it up to the guest (firmware or OS) looks more natural
>> > to me.
>>
>> I under where you are coming from in the idea of leaving it to the OS
>
>I'm coming from the HyperV spec, see the quote above.
>
>> but I think in this specific case it does not make much sense, after
>> all HyperV has it's own proprietary BIOS which Windows assumes has
>> setup some of the MSRs, since we dont have that BIOS we need to
>> "emulate" it's behaviour.
>
>We don't have that BIOS, but we have another BIOS which does the same
>and is not proprietary.  Using it allows to do synic message posting
>even with a non-compliant guest OS which doesn't properly enable
>SCONTROL on its own.  (Note that there used to be no problem with this
>so far, this must be specific to your use case.)
>
>I'm failing to see why this is a stumbling block for the work you're
>doing.
>
>And I'm not convinced we need to work around a non-compliant guest with
>kludges to KVM or QEMU (including back-compat stuff as that would change
>the existing behavior), when the desired effect can be achieved with the
>existing code.
>
>Thanks,
>Roman.

Thanks Roman, I see your point, it's important for me to get the EDK2 
working properly not sure why it's not working for me.

Do you know by any chance if the EDK2 hyperv patches were submitted and 
if they were why they were not merged in?

Thanks,
-- Jon.
