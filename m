Return-Path: <kvm+bounces-3684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81D60806BE1
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 11:26:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DB212815E1
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 10:26:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0CF22D7B7;
	Wed,  6 Dec 2023 10:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K9zGkF/Z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C968F
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 02:26:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701858379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ik0sT8ye2FBvhBYVnvhMEyxxJaRtPTNqO+d0WeH4eEE=;
	b=K9zGkF/ZfMcbYV+E77oK2zeOdCpsP4qkkdvReU17SgiQB2i6mUMuCcMsFgWulZoDetc37K
	oSTOSR1yVIl90uDz3ffFeAORPWNhXRKJsb2xEC/mwBVWLhow6UmElM7gCURT50aLeh6gGx
	cncc9j/EfpqiH5d+8OA0zN5rLamdNHk=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-ciLxqNa1Ox6ia__pYAzlWg-1; Wed, 06 Dec 2023 05:26:17 -0500
X-MC-Unique: ciLxqNa1Ox6ia__pYAzlWg-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-50be5899082so3963748e87.2
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 02:26:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701858373; x=1702463173;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ik0sT8ye2FBvhBYVnvhMEyxxJaRtPTNqO+d0WeH4eEE=;
        b=Xwt8tVm3Rze9vZLacEt0U3OtAVBqTaHQpqMiy+5oOuUW/S0GPrP9rjoMx9pMcyEc+V
         S9Pf5Jrl65HsRuay4ZzTMcsJveLKF2l1cRvmyYT1fqZpziIs4uW9noBQOJzX3iZrwLT5
         i2cyN7RQHiDt8bEX5npTu6Fn4JVz28EIG8d+fTcSNRQbeIaSqpdMKa52Vgosavf603QM
         4LCwcOP0Yj7UogeP36IOf3Px/eikXmeMWLh/6Z8UVQOuNp9yfXx1RNxaCPH78QewcQ4c
         pIS+KrtNg0F8VM5yDbIJ5U/ehqQBojPATBQlGtJYGFO6vvdFgUD7MQfkshA/SM4XYbQw
         8upw==
X-Gm-Message-State: AOJu0YyyLpOPjWygVmK+p4oKWpRB6HT9RqxkTqLxHmrtmF4twkowVthl
	2QQooHRpLkhBJn2dGJn1RjLMh5GlGPvZ+ha5r0CGnaIXIFXfI6LHeFNibXtMlnVQc5yQ9CVw9VE
	bNDG0IqweNBa5naSaYIkxx3k3L+bq
X-Received: by 2002:ac2:5f8d:0:b0:50b:f553:81ba with SMTP id r13-20020ac25f8d000000b0050bf55381bamr353611lfe.9.1701858373041;
        Wed, 06 Dec 2023 02:26:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG526lYnSiCxnFcggxENPqFP3O+Jii+dutxJBc2FPyRRLkp0LGZiMcNiJ79zm36w+K3hftLf3H/WUpKxZNmbeU=
X-Received: by 2002:ac2:5f8d:0:b0:50b:f553:81ba with SMTP id
 r13-20020ac25f8d000000b0050bf55381bamr353600lfe.9.1701858372764; Wed, 06 Dec
 2023 02:26:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230420120948.436661-1-stefanha@redhat.com> <20230420120948.436661-21-stefanha@redhat.com>
In-Reply-To: <20230420120948.436661-21-stefanha@redhat.com>
From: Carlos Santos <casantos@redhat.com>
Date: Wed, 6 Dec 2023 07:26:01 -0300
Message-ID: <CAC1VKkMadcEV4+UwXQQEONTBnw=xfmFC2MeUoruMRNkOLK0+qg@mail.gmail.com>
Subject: Re: [PULL 20/20] tracing: install trace events file only if necessary
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: qemu-devel@nongnu.org, Raphael Norwitz <raphael.norwitz@nutanix.com>, 
	Kevin Wolf <kwolf@redhat.com>, Markus Armbruster <armbru@redhat.com>, Julia Suvorova <jusual@redhat.com>, 
	Eric Blake <eblake@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Thomas Huth <thuth@redhat.com>, qemu-block@nongnu.org, 
	Cornelia Huck <cohuck@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, 
	=?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Peter Maydell <peter.maydell@linaro.org>, Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org, 
	virtio-fs@redhat.com, Hanna Reitz <hreitz@redhat.com>, Fam Zheng <fam@euphon.net>, 
	Aarushi Mehta <mehta.aaru20@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 20, 2023 at 9:10=E2=80=AFAM Stefan Hajnoczi <stefanha@redhat.co=
m> wrote:
>
> From: Carlos Santos <casantos@redhat.com>
>
> It is not useful when configuring with --enable-trace-backends=3Dnop.
>
> Signed-off-by: Carlos Santos <casantos@redhat.com>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> Message-Id: <20230408010410.281263-1-casantos@redhat.com>
> ---
>  trace/meson.build | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/trace/meson.build b/trace/meson.build
> index 8e80be895c..30b1d942eb 100644
> --- a/trace/meson.build
> +++ b/trace/meson.build
> @@ -64,7 +64,7 @@ trace_events_all =3D custom_target('trace-events-all',
>                                   input: trace_events_files,
>                                   command: [ 'cat', '@INPUT@' ],
>                                   capture: true,
> -                                 install: true,
> +                                 install: get_option('trace_backends') !=
=3D [ 'nop' ],
>                                   install_dir: qemu_datadir)
>
>  if 'ust' in get_option('trace_backends')
> --
> 2.39.2
>

Hello,

I still don't see this in the master branch. Is there something
preventing it from being applied?

--=20
Carlos Santos
Senior Software Maintenance Engineer
Red Hat
casantos@redhat.com    T: +55-11-3534-6186


