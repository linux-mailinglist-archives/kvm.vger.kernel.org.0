Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 008401182A6
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 09:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbfLJIpb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 03:45:31 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53648 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726847AbfLJIpb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Dec 2019 03:45:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575967530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EHXP5t+IM2uhgjKRfv/wbmhkBiYk2XdPfXl9QksfvlM=;
        b=KatolIN1cHLaczICZaIKPlIgc9FZeYueUDNyaoiOzDJF2+2FFz4MikODvW4rnpylETC+63
        wKwAEuLImgMLN57GRsBo3WjBqmMiiVYcfE1Od2qBf5ZwAfY0gBDUARBa1ZtTuKZcEBs8dk
        AIKEJys9KzJsCE/rJ1EoN6aJNnJ1IAU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-Z_veY5N_NUi2heCMpgpsHw-1; Tue, 10 Dec 2019 03:45:29 -0500
Received: by mail-wr1-f69.google.com with SMTP id c6so8615282wrm.18
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 00:45:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=VokcWwHWpp/e0pbVRBSEYqvNuANdyNAiEOTcGwXXE2w=;
        b=FpThEm6MSKsIFQlZPQOierNU2Dvmyi4c8EcjoLH8ScFSJlDCbPRPngnR38UgOeh1pU
         gITGNVcrssVFydJsntbm+2QhgXi+GZRfyXCpU1Pvk93Xm60xFJlHIurIxcKlqxYd/9E0
         23ttBYggoDnuN+2NMqvznLVQMDfdgvL20BkalYGF0TloU3uxzxWW27nTw/yEo+C+vKAw
         rteIyTFea1Dio7yqE+2IkADVFNmr6YOUDaSMqk5L/tOZl6cvtxgezoEemoWB5RRabXhT
         XeR4nQD3SY5XCEbkZLSbCNVHojJ2SsvyujIvE/Pk+woqfzI6YNCswo13q6UzxZN02OUB
         OwTA==
X-Gm-Message-State: APjAAAWbDS2cm6ksY1D9W5aJEgg6WdHjSceyA3e8ebcadRGW3bgTCQKO
        v2QOhLdBWdMPjpOsP85j05XlGRXk3ZyNCZkGkTNsjUQWR8HsoWqPxoga3eLiAac2Q/mgnGnAHAK
        1e6Tn8MMsmiZx
X-Received: by 2002:adf:fc0c:: with SMTP id i12mr1933194wrr.74.1575967528510;
        Tue, 10 Dec 2019 00:45:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqyIp7r0+7xXZilpVXZLekeS10O68sMVivmUq43xh4m2WJkFH6LFJJFSQebYaSTyZIF9OhpDow==
X-Received: by 2002:adf:fc0c:: with SMTP id i12mr1933169wrr.74.1575967528224;
        Tue, 10 Dec 2019 00:45:28 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id s1sm2289452wmc.23.2019.12.10.00.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 00:45:27 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com,
        gshan@redhat.com
Subject: Re: [PATCH] tools/kvm_stat: Fix kvm_exit filter name
In-Reply-To: <20191210044829.180122-1-gshan@redhat.com>
References: <20191210044829.180122-1-gshan@redhat.com>
Date:   Tue, 10 Dec 2019 09:45:27 +0100
Message-ID: <871rtcd0wo.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-MC-Unique: Z_veY5N_NUi2heCMpgpsHw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Gavin Shan <gshan@redhat.com> writes:

> The filter name is fixed to "exit_reason" for some kvm_exit events, no
> matter what architect we have. Actually, the filter name ("exit_reason")
> is only applicable to x86, meaning it's broken on other architects
> including aarch64.
>
> This fixes the issue by providing various kvm_exit filter names, dependin=
g
> on architect we're on. Afterwards, the variable filter name is picked and
> applied through ioctl(fd, SET_FILTER).

Would it actually make sense to standardize (to certain extent) kvm_exit
tracepoints instead?

>
> Reported-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  tools/kvm/kvm_stat/kvm_stat | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
> index ad1b9e646c49..f9273614b7e3 100755
> --- a/tools/kvm/kvm_stat/kvm_stat
> +++ b/tools/kvm/kvm_stat/kvm_stat
> @@ -270,6 +270,7 @@ class ArchX86(Arch):
>      def __init__(self, exit_reasons):
>          self.sc_perf_evt_open =3D 298
>          self.ioctl_numbers =3D IOCTL_NUMBERS
> +        self.exit_field =3D 'exit_reason'

Also, 'exit_field' name is confusing (probably because I'm thinking of
VMCS fields)

>          self.exit_reasons =3D exit_reasons
> =20
>      def debugfs_is_child(self, field):
> @@ -289,6 +290,7 @@ class ArchPPC(Arch):
>          # numbers depend on the wordsize.
>          char_ptr_size =3D ctypes.sizeof(ctypes.c_char_p)
>          self.ioctl_numbers['SET_FILTER'] =3D 0x80002406 | char_ptr_size =
<< 16
> +        self.exit_field =3D 'exit_nr'
>          self.exit_reasons =3D {}
> =20
>      def debugfs_is_child(self, field):
> @@ -300,6 +302,7 @@ class ArchA64(Arch):
>      def __init__(self):
>          self.sc_perf_evt_open =3D 241
>          self.ioctl_numbers =3D IOCTL_NUMBERS
> +        self.exit_field =3D 'ret'

And this is the most confusing part. Why do we have 'ret' as an exit
reason in the first place?

>          self.exit_reasons =3D AARCH64_EXIT_REASONS
> =20
>      def debugfs_is_child(self, field):
> @@ -311,6 +314,7 @@ class ArchS390(Arch):
>      def __init__(self):
>          self.sc_perf_evt_open =3D 331
>          self.ioctl_numbers =3D IOCTL_NUMBERS
> +        self.exit_field =3D None
>          self.exit_reasons =3D None
> =20
>      def debugfs_is_child(self, field):
> @@ -541,8 +545,8 @@ class TracepointProvider(Provider):
>          """
>          filters =3D {}
>          filters['kvm_userspace_exit'] =3D ('reason', USERSPACE_EXIT_REAS=
ONS)
> -        if ARCH.exit_reasons:
> -            filters['kvm_exit'] =3D ('exit_reason', ARCH.exit_reasons)
> +        if ARCH.exit_field and ARCH.exit_reasons:
> +            filters['kvm_exit'] =3D (ARCH.exit_field, ARCH.exit_reasons)
>          return filters
> =20
>      def _get_available_fields(self):

--=20
Vitaly

