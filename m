Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49705197823
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 11:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgC3J6I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 05:58:08 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:59495 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727183AbgC3J6H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 05:58:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585562286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QMWF8QuFs4FdQnn5PR+iMqYMNcjozcoCRuj7TDfrrJM=;
        b=CIwAxxrh9aBXP2eU4/NBIuKlbggktT2hno42JatxcizjFJSqbcEpITooORCiaKSkI3v5iC
        9GvGjFsFaDUfaq89xxZ7jStSKvCbXL/iH9i2hVUfArKFuKVhDzjeNlEy+hQEF836047VS5
        w9vnYucCvE5ZiN/1xw1axtoOJRzxxZs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-a80OJPh6OOmn0-tzar3j5w-1; Mon, 30 Mar 2020 05:58:02 -0400
X-MC-Unique: a80OJPh6OOmn0-tzar3j5w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72A47800D50;
        Mon, 30 Mar 2020 09:58:00 +0000 (UTC)
Received: from [10.36.112.58] (ovpn-112-58.ams2.redhat.com [10.36.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CFC05C1B5;
        Mon, 30 Mar 2020 09:57:57 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v7 09/13] arm/arm64: ITS: Commands
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, drjones@redhat.com,
        andre.przywara@arm.com, peter.maydell@linaro.org,
        alexandru.elisei@arm.com, thuth@redhat.com
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-10-eric.auger@redhat.com>
 <84493416-7b0d-df3e-df56-cedcbdd72010@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <885f656f-08a4-7e7b-f2b8-0e3921a58bb9@redhat.com>
Date:   Mon, 30 Mar 2020 11:57:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <84493416-7b0d-df3e-df56-cedcbdd72010@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 3/30/20 11:22 AM, Zenghui Yu wrote:
> Hi Eric,
>=20
> On 2020/3/20 17:24, Eric Auger wrote:
>> Implement main ITS commands. The code is largely inherited from
>> the ITS driver.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>=20
> [...]
>=20
>> +/* ITS COMMANDS */
>> +
>> +static void its_encode_cmd(struct its_cmd_block *cmd, u8 cmd_nr)
>> +{
>> +=C2=A0=C2=A0=C2=A0 cmd->raw_cmd[0] &=3D ~0xffUL;
>> +=C2=A0=C2=A0=C2=A0 cmd->raw_cmd[0] |=3D cmd_nr;
>> +}
>> +
>> +static void its_encode_devid(struct its_cmd_block *cmd, u32 devid)
>> +{
>> +=C2=A0=C2=A0=C2=A0 cmd->raw_cmd[0] &=3D BIT_ULL(32) - 1;
>> +=C2=A0=C2=A0=C2=A0 cmd->raw_cmd[0] |=3D ((u64)devid) << 32;
>> +}
>> +
>> +static void its_encode_event_id(struct its_cmd_block *cmd, u32 id)
>> +{
>> +=C2=A0=C2=A0=C2=A0 cmd->raw_cmd[1] &=3D ~0xffffffffUL;
>> +=C2=A0=C2=A0=C2=A0 cmd->raw_cmd[1] |=3D id;
>> +}
>> +
>> +static void its_encode_phys_id(struct its_cmd_block *cmd, u32 phys_id=
)
>> +{
>> +=C2=A0=C2=A0=C2=A0 cmd->raw_cmd[1] &=3D 0xffffffffUL;
>> +=C2=A0=C2=A0=C2=A0 cmd->raw_cmd[1] |=3D ((u64)phys_id) << 32;
>> +}
>> +
>> +static void its_encode_size(struct its_cmd_block *cmd, u8 size)
>> +{
>> +=C2=A0=C2=A0=C2=A0 cmd->raw_cmd[1] &=3D ~0x1fUL;
>> +=C2=A0=C2=A0=C2=A0 cmd->raw_cmd[1] |=3D size & 0x1f;
>> +}
>> +
>> +static void its_encode_itt(struct its_cmd_block *cmd, u64 itt_addr)
>> +{
>> +=C2=A0=C2=A0=C2=A0 cmd->raw_cmd[2] &=3D ~0xffffffffffffUL;
>> +=C2=A0=C2=A0=C2=A0 cmd->raw_cmd[2] |=3D itt_addr & 0xffffffffff00UL;
>> +}
>> +
>> +static void its_encode_valid(struct its_cmd_block *cmd, int valid)
>> +{
>> +=C2=A0=C2=A0=C2=A0 cmd->raw_cmd[2] &=3D ~(1UL << 63);
>> +=C2=A0=C2=A0=C2=A0 cmd->raw_cmd[2] |=3D ((u64)!!valid) << 63;
>> +}
>> +
>> +static void its_encode_target(struct its_cmd_block *cmd, u64
>> target_addr)
>> +{
>> +=C2=A0=C2=A0=C2=A0 cmd->raw_cmd[2] &=3D ~(0xfffffffffUL << 16);
>> +=C2=A0=C2=A0=C2=A0 cmd->raw_cmd[2] |=3D (target_addr & (0xffffffffUL =
<< 16));
>> +}
>> +
>> +static void its_encode_collection(struct its_cmd_block *cmd, u16 col)
>> +{
>> +=C2=A0=C2=A0=C2=A0 cmd->raw_cmd[2] &=3D ~0xffffUL;
>> +=C2=A0=C2=A0=C2=A0 cmd->raw_cmd[2] |=3D col;
>> +}
>=20
> The command encoding can be refactored like:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D4d36f136d57aea6f6440886106e246bb7e5918d8
>=20
>=20
> which will look much clearer.
OK
>=20
> [...]
>=20
>> +static void its_send_single_command(its_cmd_builder_t builder,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct its_cmd_desc *desc)
>> +{
>> +=C2=A0=C2=A0=C2=A0 struct its_cmd_block *cmd, *next_cmd;
>> +
>> +=C2=A0=C2=A0=C2=A0 cmd =3D its_allocate_entry();
>> +=C2=A0=C2=A0=C2=A0 builder(cmd, desc);
>> +=C2=A0=C2=A0=C2=A0 next_cmd =3D its_post_commands();
>> +
>> +=C2=A0=C2=A0=C2=A0 its_wait_for_range_completion(cmd, next_cmd);
>> +}
>> +
>> +
>=20
> extra line.
OK
>=20
>> +static void its_build_mapd_cmd(struct its_cmd_block *cmd,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct its_cmd_desc *desc)
>> +{
>> +=C2=A0=C2=A0=C2=A0 unsigned long itt_addr;
>> +=C2=A0=C2=A0=C2=A0 u8 size =3D 12; /* 4096 eventids */
>=20
> Maybe use desc->its_mapd_cmd.dev->nr_ites instead as we already have it=
?
OK
>=20
>> +
>> +=C2=A0=C2=A0=C2=A0 itt_addr =3D (unsigned
>> long)(virt_to_phys(desc->its_mapd_cmd.dev->itt));
>> +=C2=A0=C2=A0=C2=A0 itt_addr =3D ALIGN(itt_addr, ITS_ITT_ALIGN);
>> +
>> +=C2=A0=C2=A0=C2=A0 its_encode_cmd(cmd, GITS_CMD_MAPD);
>> +=C2=A0=C2=A0=C2=A0 its_encode_devid(cmd, desc->its_mapd_cmd.dev->devi=
ce_id);
>> +=C2=A0=C2=A0=C2=A0 its_encode_size(cmd, size - 1);
>> +=C2=A0=C2=A0=C2=A0 its_encode_itt(cmd, itt_addr);
>> +=C2=A0=C2=A0=C2=A0 its_encode_valid(cmd, desc->its_mapd_cmd.valid);
>> +=C2=A0=C2=A0=C2=A0 its_fixup_cmd(cmd);
>> +=C2=A0=C2=A0=C2=A0 if (desc->verbose)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 printf("ITS: MAPD devid=3D=
%d size =3D 0x%x itt=3D0x%lx valid=3D%d\n",
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 de=
sc->its_mapd_cmd.dev->device_id,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 si=
ze, itt_addr, desc->its_mapd_cmd.valid);
>> +
>=20
> extra line.
>=20
> All of these are trivial things and feel free to ignore them,
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
thanks!

Eric
>=20
>=20
> Thanks
>=20

