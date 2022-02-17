Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399C84BA5D7
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 17:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243155AbiBQQ1s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 11:27:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243126AbiBQQ1n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 11:27:43 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7339A9A3
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 08:27:28 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id i21so87906pfd.13
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 08:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=piQ+AaR3KsfxzywPotTriUaX9sZGJi9bo2vWFUyvr+0=;
        b=IPuPL/0GHf/dpxy+pzB1u+LDafPWP5/f3U69d43m2A8ZhtxqSNBInKUNYTpgDJxJaI
         rB8GPWIc9laFMpliQ7+tggGm74Pcyl7hm0OYnLzGXnzkhe0g+7Sz3Q0e0/BjItPp9FP2
         pGUChT73yGVtNTV42H+nZ23BFXyYlu4wVLjtDg8u3gimuQhw7BPKW1sFM76PDu4ZxVL5
         fCEE6OejQcqsf3w9UbMbh1lxtvPh1TVQnu8Mld/r6wz60coKHFm3rWqWx4v7vt0kqGXe
         C/suJdIg2fkTVDIWZh3drthWdIL6fP+tvqckzRX71tjhQTKwO4IRs/sNbO2ljhNCuZrx
         pc2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=piQ+AaR3KsfxzywPotTriUaX9sZGJi9bo2vWFUyvr+0=;
        b=bjZPO037yebs22ia4HpohZKhe220a+xzQqWOJi5nCM5VsVfSjndrQuqSVxM18YRgDj
         fOKZPxX82hm8fvm2uptqd8HyPmIo+YtXhTSa2FaiOn+MRl1ME1PnlFcFFnZiqj7yHk/W
         6bFs5BpkBYoo2tzWukZX4lIfjrybmyvLtBXYuuVBHHp0iseShs4I6JjbKIOZGNg/aun1
         ArSwnFv4XZWKiXmPkNLt/9EOf1LmRgw0+mlmO8WXcF1geuE7xL0zvvSdJQ5RLdlpUWTj
         UdI7sRjRnJG5NEHCpqOa1P8Vq+MQk9sjEQttM124WmDbP30yOM7rxNd0qw/MUCmFIM+R
         l03Q==
X-Gm-Message-State: AOAM533W61kxp34RWl14/IRuWSHMFhMDkfHoL8mf+uFgqNcPYT8aK1Ae
        e+GN2EvqwEcx2ECUe01IQrWUZhkrBzRbbkwSwSA=
X-Google-Smtp-Source: ABdhPJytgt0YENDw9hnPicJYfG/fGeOktmqueccgIcnX0IbjzMVWRrB8maZaYXhIJGUxmc/PUTjf5n8/8JwUFPVTbDQ=
X-Received: by 2002:a05:6a00:1a8d:b0:4e1:cde3:7bf7 with SMTP id
 e13-20020a056a001a8d00b004e1cde37bf7mr2489791pfv.52.1645115248071; Thu, 17
 Feb 2022 08:27:28 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <CACGkMEvtENvpubmZY3UKptD-T=c9+JJV1kRm-ZPhP08xOJv2fQ@mail.gmail.com>
 <CAJSP0QX6JgCG7UdqaY=G8rc64ZqE912UzM7pQkSMBfzGywHaHg@mail.gmail.com> <20220217141227.sk7hfng7raq6xvuh@sgarzare-redhat>
In-Reply-To: <20220217141227.sk7hfng7raq6xvuh@sgarzare-redhat>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Thu, 17 Feb 2022 16:27:16 +0000
Message-ID: <CAJSP0QVVehjYpFodccZsQUew_LM6Yz5rfdFDSAvP1-+vHKwLgA@mail.gmail.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        John Snow <jsnow@redhat.com>, Sergio Lopez <slp@redhat.com>,
        "Florescu, Andreea" <fandree@amazon.com>,
        Alex Agache <aagch@amazon.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 17 Feb 2022 at 14:12, Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> On Mon, Feb 14, 2022 at 02:01:52PM +0000, Stefan Hajnoczi wrote:
> >On Mon, 14 Feb 2022 at 07:11, Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On Fri, Jan 28, 2022 at 11:47 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
> >> >
> >> > Dear QEMU, KVM, and rust-vmm communities,
> >> > QEMU will apply for Google Summer of Code 2022
> >> > (https://summerofcode.withgoogle.com/) and has been accepted into
> >> > Outreachy May-August 2022 (https://www.outreachy.org/). You can now
> >> > submit internship project ideas for QEMU, KVM, and rust-vmm!
> >> >
> >> > If you have experience contributing to QEMU, KVM, or rust-vmm you can
> >> > be a mentor. It's a great way to give back and you get to work with
> >> > people who are just starting out in open source.
> >> >
> >> > Please reply to this email by February 21st with your project ideas.
> >> >
> >> > Good project ideas are suitable for remote work by a competent
> >> > programmer who is not yet familiar with the codebase. In
> >> > addition, they are:
> >> > - Well-defined - the scope is clear
> >> > - Self-contained - there are few dependencies
> >> > - Uncontroversial - they are acceptable to the community
> >> > - Incremental - they produce deliverables along the way
> >> >
> >> > Feel free to post ideas even if you are unable to mentor the project.
> >> > It doesn't hurt to share the idea!
> >>
> >> Implementing the VIRTIO_F_IN_ORDER feature for both Qemu and kernel
> >> (vhost/virtio drivers) would be an interesting idea.
> >>
> >> It satisfies all the points above since it's supported by virtio spec.
> >>
> >> (Unfortunately, I won't have time in the mentoring)
> >
> >Thanks for this idea. As a stretch goal we could add implementing the
> >packed virtqueue layout in Linux vhost, QEMU's libvhost-user, and/or
> >QEMU's virtio qtest code.
> >
> >Stefano: Thank you for volunteering to mentor the project. Please
> >write a project description (see template below) and I will add this
> >idea:
> >
>
> I wrote a description of the project below. Let me know if there is
> anything to change.

Thanks, I have added the idea:
https://wiki.qemu.org/Google_Summer_of_Code_2022#VIRTIO_F_IN_ORDER_support_for_virtio_devices

Stefan
