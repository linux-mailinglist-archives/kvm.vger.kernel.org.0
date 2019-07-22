Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E616870A86
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2019 22:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729621AbfGVUUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jul 2019 16:20:02 -0400
Received: from mail-ot1-f43.google.com ([209.85.210.43]:38817 "EHLO
        mail-ot1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729143AbfGVUUC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jul 2019 16:20:02 -0400
Received: by mail-ot1-f43.google.com with SMTP id d17so41665711oth.5
        for <kvm@vger.kernel.org>; Mon, 22 Jul 2019 13:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc;
        bh=tRJ8beDcV8PriB7x/0XycZFmvH/c1FBEDpMLPyl71Jc=;
        b=veV4JdoJWrNBwczX1MgO4HPM5lS6yPNfS/Tf172pXYcCRW0mrBwHLbe/OHsNesJPpH
         VC5QcFnhgbLlRIrrlxsJINQf1Rvg/1f/sC4tOPjGB8jQaNRcVURqFGX0IcSbk79QIJp4
         hPWQNUtZeNYhGjdBMuYT/SWCI9+0G/JLJSgHjXraZu1IbQEGqgigdSBgGOEgmM5LdiFd
         bvNe4wn9+x8iHKvAD3y2YbTse4VzSt7zVSPCoakCyEPUYxz3EkJPdH7NUK1kgdbqVKOS
         3SNcKijtgsXy5sP5oi6zfY2oXFwxAmhIxvr1D4oUh6raWHwu6N6Hm7Sl5EwDHTHAOGp2
         vClQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc;
        bh=tRJ8beDcV8PriB7x/0XycZFmvH/c1FBEDpMLPyl71Jc=;
        b=YmZFN0gInYYiID/vLQLsW/w0B6m02Yy445Y0mCowq3UsFXp5HAq9wcHezRb8syjAfo
         ST3553xB/xI2RP5l2YGalbkWo+6+dM8V6oqoC9l0pVmLEgkSR0NRmO4RUWBKETRrNOTH
         JNyq2UMGwkf5kMBzTJ/NQ8wt6tS7FGNMvv7O6uWXrnMxjn0g7RoNDbIQnYlt4FOpw0rM
         3FycKJOoRoJukVYmmn6VoMOvDY7BejIpVSRhBXzD2Usn/RRSQ0k4m7iKBschOLeorNA4
         tGhBc46C/llmkTifxyODugqOy3C7y/1CqlL5Td1HHtIVQD/jzHk8nSxGH3ef6uDgT+OE
         q0TA==
X-Gm-Message-State: APjAAAUfgla/yxpFASKEw3tDfjfybloH6pPv+LlwK2fkDMb+RYHm032w
        Fdr9uGQ0YcU+gNDcvFa/3r6IaIYPOr9g9L+0qPry8Q==
X-Google-Smtp-Source: APXvYqwNy14SIr6IWL2qV3jZssyLOoJlgZI2kQ1Dd/pwR/zHniB348szxeIbX9futzbSy5Mg8eag3ACIdHG1Jrtmzkk=
X-Received: by 2002:a9d:7a90:: with SMTP id l16mr1298356otn.297.1563826801626;
 Mon, 22 Jul 2019 13:20:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAD7Ssm9NRozuNBX0puYyd-JnkhNt0AonerPZfZ=Qou-5inTaRw@mail.gmail.com>
In-Reply-To: <CAD7Ssm9NRozuNBX0puYyd-JnkhNt0AonerPZfZ=Qou-5inTaRw@mail.gmail.com>
From:   Mauricio Tavares <raubvogel@gmail.com>
Date:   Mon, 22 Jul 2019 16:19:50 -0400
Message-ID: <CAHEKYV6JbsO=4k5JksGy-V6nJ40U=Pz9+bawQ3rSvz8nAC-NRA@mail.gmail.com>
Subject: Re: KVM bridge networking
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 22, 2019 at 1:27 PM Kaushal Shriyan
<kaushalshriyan@gmail.com> wrote:
>
> Hi,
>
> I am confused regarding KVM networking. I have configured base OS and guest OS.
>
> [root@baremetalinhousebaseserver1 network-scripts]# cat ifcfg-br0
> TYPE=bridge
> PROXY_METHOD=none
> BROWSER_ONLY=no
> BOOTPROTO=static
> DEFROUTE=yes
> IPV4_FAILURE_FATAL=no
> #IPV6INIT=yes
> #IPV6_AUTOCONF=yes
> #IPV6_DEFROUTE=yes
> #IPV6_FAILURE_FATAL=no
> #IPV6_ADDR_GEN_MODE=stable-privacy
> NAME=br0
> #UUID=af60e6bd-e824-44fa-a816-763e6e977ae6
> DEVICE=br0
> ONBOOT=yes
> IPADDR=192.168.0.65
> PREFIX=24
> GATEWAY=192.168.0.10
> DNS1=213.117.155.12
> DNS2=213.117.155.10
> [root@baremetainhousebaseserver1 network-scripts]# cat ifcfg-em1
> TYPE=Ethernet
> PROXY_METHOD=none
> BROWSER_ONLY=no
> BOOTPROTO=static
> DEFROUTE=yes
> IPV4_FAILURE_FATAL=no
> IPV6INIT=yes
> IPV6_AUTOCONF=yes
> IPV6_DEFROUTE=yes
> IPV6_FAILURE_FATAL=no
> IPV6_ADDR_GEN_MODE=stable-privacy
> NAME=em1
> UUID=af60e6bd-e824-44fa-a816-763e6e977ae6
> DEVICE=em1
> ONBOOT=yes
> BRIDGE=br0
> IPADDR=192.168.0.35
> PREFIX=24
> GATEWAY=192.168.0.10
> DNS1=213.117.155.12
> DNS2=213.117.155.10
> [root@baremetainhousebaseserver1 network-scripts]#
>
> I use the below command to launch KVM guest VM
>
> #virt-install --name=qubecrafter02
> --file=/var/lib/libvirt/images/apprafter02centos7.img --file-size=50
> --nonsparse --vcpus=2 --ram=8096 --network=bridge:br0 --os-type=linux
> --os-variant=rhel7 --graphics none
> --location=/var/lib/libvirt/isos/CentOS-7-x86_64-DVD-1810.iso
> --extra-args="console=ttyS0"
>
> I do vim /etc/sysconfig/network-scripts/ifcfg-eth0 on guestosvm1
>
> [root@guestosvm1 network-scripts]# cat ifcfg-eth0
> TYPE=Ethernet
> PROXY_METHOD=none
> BROWSER_ONLY=no
> BOOTPROTO=static
> DEFROUTE=yes
> IPV4_FAILURE_FATAL=no
> IPV6INIT=yes
> IPV6_AUTOCONF=yes
> IPV6_DEFROUTE=yes
> IPV6_FAILURE_FATAL=no
> IPV6_ADDR_GEN_MODE=stable-privacy
> NAME=eth0
> UUID=805ff146-ecc1-460a-a7e2-e35eb19814c2
> DEVICE=eth0
> ONBOOT=yes
> IPADDR=192.168.0.66
> PREFIX=24
> GATEWAY=192.168.0.10
> DNS1=213.117.155.12
> DNS2=213.117.155.10
> [root@guestosvm1 network-scripts]#
>
> I am confused between bridge and ethernet networking. Am i missing
> anything in the above configurations, Please comment.
>
> Thanks in Advance and i look forward to hearing from you.
>
> Best Regards,
>
> Kaushal

Did you test if bridge was up before adding the vm guest? Why does em1
have an ip?
