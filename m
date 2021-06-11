Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067B93A4B4C
	for <lists+kvm@lfdr.de>; Sat, 12 Jun 2021 01:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhFKXla (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 19:41:30 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:40644 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbhFKXl1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 19:41:27 -0400
Received: by mail-wr1-f49.google.com with SMTP id y7so7619985wrh.7
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 16:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=3BzcyMtGkcdIGLF+yCsNPqQWyMngZNHKlYP8O/RKXbo=;
        b=bN2VUm7xI6+UykdJBI/g4IBMcZTat4SJBaDKD2QNheRxDKVY2ihs2twilE+muaBde8
         mqhYM0MLtekc3Hd/8rUKUclrgZE+ezOP/gIsF3oGpCtPEfoxKh2lv4LSuri61pWtbbt0
         IQTO4BYBussPvched1VGinFAJt619lnVDf66DnFKuO4qLgkOzPoawlifzKfNv/z/2XJ1
         wAla6YdBcsrIBTwGsOM/LTYUXU8yPchibpNUeaDkLyIIicypO9mnOmMQY7Ey7JP4QzNN
         GN/vo3MzyfAwuzIRELSDlpldJFuSih1cztodCaD/xPeGdh+bmrUqmEy1t0H36l1esk5U
         EbjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=3BzcyMtGkcdIGLF+yCsNPqQWyMngZNHKlYP8O/RKXbo=;
        b=q3dxSJNwM16kOQWbwlyhW7uv/bNbGOpZ8LEZTMDPDzViUJpTtwhxgrB02trlyjlC8E
         oJ7MPGKikIJgFlqK0Gqn7zOh87VYWAT40ld+xveCuDVvtCozqBd+oPBAvjrf2Sjz9x40
         AlHpnnWjcts6iUzxqakckTDvIcIzye8R7W4q0TqQkLi8y+4jVWn9PA9JoAFLX7el67WL
         CD+hSo3RJ/odHYvAXS52YxoKm8xyLlMkp7hmWf1HCMPIZXpLYyfqHtvbPh+AfN8Oyes2
         zjjO1T0l9LMu0C+mWT2VrVntjlcmeMX3reCBG6M2evxpgFgSl/PW2pRMog2R+OvScOq+
         eKGA==
X-Gm-Message-State: AOAM532f7BQTretBiU3u8EOV8BT2Y3qbF2gqa9gdxnz38mOFv6sDrHC1
        a4riskZaq4l8S05AcreVyWpKTC3CtEmAsTyuL8vAHJDYF8ppIw==
X-Google-Smtp-Source: ABdhPJwxGG0bJiOVPrH59UBo4S72NYgztCtE0MEnpYn10acHeEzY6AFkD7nRb3d9Ug2HFzWpDfRT16AZwSXr2cJKLfc=
X-Received: by 2002:a5d:64c2:: with SMTP id f2mr6451828wri.291.1623454694516;
 Fri, 11 Jun 2021 16:38:14 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Eduardo_L=C3=BAcio_Amorim_Costa?= 
        <eduardolucioac@gmail.com>
Date:   Fri, 11 Jun 2021 20:38:03 -0300
Message-ID: <CAN+8gCjvY-+_2MTCAT-CvbhbpxUTf-K60V9G-HBKAJHm3eV5mQ@mail.gmail.com>
Subject: KVM Virtual Machine Network - Guest-guest/VM-VM only network (no
 host/hypervisor access, no outbound connectivity)
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I know that with the virsh command I can create several types of
networks (a "NAT network", for example) as we can see in these URLs...

KVM network management ( https://programmersought.com/article/52213715009/ =
)
KVM default NAT-based networking (page 33) (
https://www.ibm.com/downloads/cas/ZVJGQX8E )

QUESTION: How can I create a network (lan_n) where only guests/VMs
have connectivity, with no outbound connectivity and no
host/hypervisor connectivity?

NOTE: The connectivity to other resources will be provided by a
pfSense firewall server that will have access to another network
(wan_n) with outbound connectivity and other resources.

Network layout...

        [N]wan_n
         =E2=86=95
        [I]wan_n
      [V]pfsense_vm
        [I]lan_n
         =E2=86=95
        [N]lan_n
         =E2=86=95
  .............................
  =E2=86=95       =E2=86=95       =E2=86=95
 [V]some_vm_0  [V]some_vm_1  [V]some_vm_4
        [V]some_vm_2  [V]some_vm_5
        [V]some_vm_3

 _ [N] - Network;
 _ [I] - Network Interface;
 _ [V] - Virtual Machine.
Thanks! =3DD

ORIGINAL QUESTION: https://serverfault.com/q/1066478/276753

--
Eduardo L=C3=BAcio
Tecnologia, Desenvolvimento e Software Livre
LightBase Consultoria em Software P=C3=BAblico
eduardo.lucio@lightbase.com.br
+55-61-3347-1949 - http://brlight.org - Brasil-DF
Software livre! Abrace essa id=C3=A9ia!
"Aqueles que negam liberdade aos outros n=C3=A3o a merecem para si mesmos."
Abraham Lincoln
