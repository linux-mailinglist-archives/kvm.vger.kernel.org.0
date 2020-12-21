Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F5B2DFB18
	for <lists+kvm@lfdr.de>; Mon, 21 Dec 2020 11:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbgLUKgs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 21 Dec 2020 05:36:48 -0500
Received: from out28-145.mail.aliyun.com ([115.124.28.145]:48050 "EHLO
        out28-145.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbgLUKgr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Dec 2020 05:36:47 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1076815|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0807833-0.00376033-0.915456;FP=7138439720345301569|3|1|1|0|-1|-1|-1;HT=ay29a033018047199;MF=cuitao@thinking-link.com;NM=1;PH=DS;RN=1;RT=1;SR=0;TI=SMTPD_---.J9jVXYF_1608546964;
Received: from LAPTOP4TTVS0FB(mailfrom:cuitao@thinking-link.com fp:SMTPD_---.J9jVXYF_1608546964)
          by smtp.aliyun-inc.com(10.194.97.246);
          Mon, 21 Dec 2020 18:36:04 +0800
From:   =?utf-8?B?5bSU5rab55qE5YWs5Y+46YKu566x?= <cuitao@thinking-link.com>
To:     <kvm@vger.kernel.org>
Subject: How to open listener on libvirtd ?
Date:   Mon, 21 Dec 2020 18:36:02 +0800
Message-ID: <006801d6d785$14afdc20$3e0f9460$@thinking-link.com>
MIME-Version: 1.0
Content-Type: text/plain;
        boundary="----=_NextPart_000_0049_01D6D7C4.F6056980";
        charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIKuTlyp+wYo/axyME59uVs5TMlLQ==
Content-Language: zh-cn
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,every one:

My Ubuntu is : 20.04 LTS, and I using libvirtd on it to make KVM vm, but now I can not open listener function of the libvirtd.


SYSTEM SOCKET ACTIVATION
       The libvirtd daemon is capable of starting in two modes.

       In the traditional mode, it will create and listen on UNIX sockets itself.  If the --listen parameter is given, it will also listen on TCP/IP socket(s),
       according to the listen_tcp and listen_tls options in /etc/libvirt/libvirtd.conf

       In socket activation mode, it will rely on systemd to create and listen on the UNIX, and optionally TCP/IP, sockets and pass them as pre-opened file de‐
       scriptors. In this mode, it is not permitted to pass the --listen parameter, and most of the socket related config options in /etc/libvirt/libvirtd.conf
       will no longer have any effect. To enable TCP or TLS sockets use either

          $ systemctl start libvirtd-tls.socket

       Or

          $ systemctl start libvirtd-tcp.socket


But, on my system, there are no such service like libvirtd-tls.socket or libvirtd-tcp.socket.

root@ubts1:~# systemctl  | grep libvirt
  libvirt-guests.service                                                                      loaded active exited    Suspend/Resume Running libvirt Guests         
  libvirtd.service                                                                            loaded active running   Virtualization daemon                         
  libvirtd-admin.socket                                                                       loaded active running   Libvirt admin socket                          
  libvirtd-ro.socket                                                                          loaded active running   Libvirt local read-only socket                
  libvirtd.socket                                                                             loaded active running   Libvirt local socket                          

How can I open the listener ?


Thanks！










