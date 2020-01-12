Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E65B81385B2
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2020 10:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732478AbgALJoD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Jan 2020 04:44:03 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40269 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732457AbgALJoD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Jan 2020 04:44:03 -0500
Received: by mail-lf1-f68.google.com with SMTP id i23so4693748lfo.7
        for <kvm@vger.kernel.org>; Sun, 12 Jan 2020 01:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=A5r5kQmyydbNcxW0sdL6UsroI3lvbIoMVRcAXoxkjxE=;
        b=W2uztqtCCOsZvughBCHSR7Y+yQr1mxzDn1SFDI/rWwPWFtLXZFMbLggsMh8BhdNUGK
         3DKBY7SeDxtbN6j4hgyKCM5XORMj8s7TsXhBBN7Oe1YdVna7cpkmv1eUw7WtE1slV4rM
         YXDYcoU8dmMIfv6qoDuY1y77XNYwXYBIh5L2OhvmIz21gFsKI5l73QU7NRXlAMW1avSS
         cwECYjHgLZE7j6QRDqSOobx6NFJBLSTC6L2l4xU23ru4U4UVFnryMejhwtLsIw8KGd8T
         aP1rcE1AsHitYur54ayIPaxs6vpXkYRMYfwbXl3YuCMRpqqZlSN3dMyI2s09n+imtO8K
         ivcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=A5r5kQmyydbNcxW0sdL6UsroI3lvbIoMVRcAXoxkjxE=;
        b=S9bG+7bi7XltukyuLJn6NbEturJU3/F780kOs5h9eZwZztZXBlvimtnrY8HU/x++Y5
         Jo9JAFWH5GQcuxQjQAIzqgdDP25FBza178NPSshT5ApFtz68eiCZxqHcJ6rI1+Xo35Ry
         5eKIMD5+GrmVqDRm03hRorgTa3n1MLAXXjY0JuOKG8SWLG8a/xsQAeDAbUY8CdQ1w8z0
         MQt1VOmi3SIzRYq+lJVqkMqG41YnCVyk4z7US3iE3OQj+7Zzh+ZjtlkH94QRYQCGwxPR
         S4UdUZrG8OJc0wc2eBj7DYp94HXFl8SoQlUd1l4vVXqSVdxLjApVBpWWQGD5b7548HMs
         BHZQ==
X-Gm-Message-State: APjAAAWPYTmvPggYtuIoTb80XTmfIiXoR2TCHpIwSg7h8ByfqZw/7Zik
        rGCY8czmbIsFSxV0J/6YjDDxUtDocld09EF46W9LvH9O
X-Google-Smtp-Source: APXvYqxudU83t852Cung1NJ91OYhHW64oFFGsNTbxqcJwhUfkWZZCHQPQzNyAs+FFdhZr50z28lxbu77NQ5sBJUz1O4=
X-Received: by 2002:ac2:5f68:: with SMTP id c8mr4913919lfc.196.1578822241492;
 Sun, 12 Jan 2020 01:44:01 -0800 (PST)
MIME-Version: 1.0
References: <20200109152133.23649-1-philmd@redhat.com> <20200109152133.23649-7-philmd@redhat.com>
In-Reply-To: <20200109152133.23649-7-philmd@redhat.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Sun, 12 Jan 2020 17:43:33 +0800
Message-ID: <CAKmqyKN9nEEJW3Jvw6b-4nT=oqHF3DkkReEZa2GGfjFu=7qWaw@mail.gmail.com>
Subject: Re: [PATCH 06/15] migration/savevm: Replace current_machine by qdev_get_machine()
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>
Cc:     "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "open list:Overall" <kvm@vger.kernel.org>,
        Juan Quintela <quintela@redhat.com>,
        "open list:New World" <qemu-ppc@nongnu.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        qemu-arm <qemu-arm@nongnu.org>,
        Alistair Francis <alistair.francis@wdc.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 9, 2020 at 11:30 PM Philippe Mathieu-Daud=C3=A9
<philmd@redhat.com> wrote:
>
> As we want to remove the global current_machine,
> replace MACHINE_GET_CLASS(current_machine) by
> MACHINE_GET_CLASS(qdev_get_machine()).
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>

Reviewed-by: Alistair Francis <alistair.francis@wdc.com>

Alistair

> ---
>  migration/savevm.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/migration/savevm.c b/migration/savevm.c
> index 59efc1981d..0e8b6a4715 100644
> --- a/migration/savevm.c
> +++ b/migration/savevm.c
> @@ -292,7 +292,8 @@ static uint32_t get_validatable_capabilities_count(vo=
id)
>  static int configuration_pre_save(void *opaque)
>  {
>      SaveState *state =3D opaque;
> -    const char *current_name =3D MACHINE_GET_CLASS(current_machine)->nam=
e;
> +    MachineClass *mc =3D MACHINE_GET_CLASS(qdev_get_machine());
> +    const char *current_name =3D mc->name;
>      MigrationState *s =3D migrate_get_current();
>      int i, j;
>
> @@ -362,7 +363,8 @@ static bool configuration_validate_capabilities(SaveS=
tate *state)
>  static int configuration_post_load(void *opaque, int version_id)
>  {
>      SaveState *state =3D opaque;
> -    const char *current_name =3D MACHINE_GET_CLASS(current_machine)->nam=
e;
> +    MachineClass *mc =3D MACHINE_GET_CLASS(qdev_get_machine());
> +    const char *current_name =3D mc->name;
>
>      if (strncmp(state->name, current_name, state->len) !=3D 0) {
>          error_report("Machine type received is '%.*s' and local is '%s'"=
,
> @@ -615,9 +617,7 @@ static void dump_vmstate_vmsd(FILE *out_file,
>
>  static void dump_machine_type(FILE *out_file)
>  {
> -    MachineClass *mc;
> -
> -    mc =3D MACHINE_GET_CLASS(current_machine);
> +    MachineClass *mc =3D MACHINE_GET_CLASS(qdev_get_machine());
>
>      fprintf(out_file, "  \"vmschkmachine\": {\n");
>      fprintf(out_file, "    \"Name\": \"%s\"\n", mc->name);
> --
> 2.21.1
>
>
