Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8AD715FD23
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2020 07:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbgBOGjI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Feb 2020 01:39:08 -0500
Received: from mail-bgr052103192033.outbound.protection.outlook.com ([52.103.192.33]:9040
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725797AbgBOGjI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Feb 2020 01:39:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cupALL1KoTeOps6IubUOKRoGbSEObCZ0PcW4RTuvppGt9vK03oE4LylBDVYjwvXmi87/7YWier9ic2/xfK67F9Gs/BXqxA28jYJ4xgRXlDdEefgJd3jUzoyS8Qt6F52/ZL0gjlIYoRJFQgiNP21gY80sXYloclm1Ff4JVO7lH84k38i+xBTo9ZSb4esMp96ekW04R1QN32CI3tixJn/6JDzFchsqy6tfkc8avbWDvknL+lUNR14+k9Jaoi0FXTJ0SOduULQRSFmVmCTqoOcYTtHIAJaaifwDI/aZTeOqqHBIp88++0S8ZUe9cHU4It8frgJzu3nBhC8fzPwMznXe7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LKfXzZhrETjO9ammTqAW2ZPXWPqGQ6x/wVkUDx3G+SQ=;
 b=k2547I3t6dk2TGA/sdzB5DzMLCsQPru/UZE//qZgUQbLKeuGDXciP9Xzv5A2e/K1W9QKzN8GD8y+YtnzagnEKKtSDR0KnBxz8SI0RoCfbzotGjT/e4lxDwUqkE1m1rcJwyTKMK2Nn+MqEOEmvlHE92yEdhxOjflRmrO+msP8m1cDeAgDXHMJuguFkoHnWa1Fj0Nn7LHqod2NXUASULdZJTpEYqWMnN/HUP2KgHMHuB7wS+9iDhBkMBnPPzytYzAyCRbY79Ax0/nS+a/ZNpROZP36dCgStxPWJyW3taWlu89TzdGy0h65POHCFEfwjv6n/UJXXCCvaZgXGaf6JBk8ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=teo-en-ming-corp.com; dmarc=pass action=none
 header.from=teo-en-ming-corp.com; dkim=pass header.d=teo-en-ming-corp.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=teoenmingcorp.onmicrosoft.com; s=selector2-teoenmingcorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LKfXzZhrETjO9ammTqAW2ZPXWPqGQ6x/wVkUDx3G+SQ=;
 b=auN3PEt9jWriWspggG213O3B8yDPqB64Tspz3A2/MrDFTf8TUgp2lkc8NVxiXmVOUzYuAj/6zraeRQH3kkPOJU0ZynvuF+arljuWER60RYG95a+osZpCK2KrIox4CzMdHngDMUVSnMdRRWOWmv5VDNMwNvqBGI2L0O2XlAWtcaU=
Received: from SG2PR01MB2141.apcprd01.prod.exchangelabs.com (10.170.143.19) by
 SG2PR01MB2141.apcprd01.prod.exchangelabs.com (10.170.143.19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.27; Sat, 15 Feb 2020 06:38:50 +0000
Received: from SG2PR01MB2141.apcprd01.prod.exchangelabs.com
 ([fe80::684a:9e0b:7e12:18bd]) by SG2PR01MB2141.apcprd01.prod.exchangelabs.com
 ([fe80::684a:9e0b:7e12:18bd%4]) with mapi id 15.20.2729.027; Sat, 15 Feb 2020
 06:38:50 +0000
From:   Turritopsis Dohrnii Teo En Ming <ceo@teo-en-ming-corp.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Turritopsis Dohrnii Teo En Ming <ceo@teo-en-ming-corp.com>
Subject: Teo En Ming's Manual for Setting Up Samba 4.11.6 and CentOS 8.1
 (1911) Linux Server QEMU/KVM Virtual Machine as an Active Directory Domain
 Controller (AD DC)
Thread-Topic: Teo En Ming's Manual for Setting Up Samba 4.11.6 and CentOS 8.1
 (1911) Linux Server QEMU/KVM Virtual Machine as an Active Directory Domain
 Controller (AD DC)
Thread-Index: AQHV48qMn3qCS29op0+OoLvUggX7BQ==
Date:   Sat, 15 Feb 2020 06:38:50 +0000
Message-ID: <SG2PR01MB21410FC1931594D546E1818087140@SG2PR01MB2141.apcprd01.prod.exchangelabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=teo-en-ming-corp.com;
x-originating-ip: [2401:7400:c802:de67:1d7c:e98d:1384:ef4c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47157d19-d027-44d9-e5a9-08d7b1e1b79a
x-ms-traffictypediagnostic: SG2PR01MB2141:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SG2PR01MB214157C7B78079A2E5A7D44187140@SG2PR01MB2141.apcprd01.prod.exchangelabs.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 03142412E2
x-forefront-antispam-report: SFV:SPM;SFS:(10001);DIR:OUT;SFP:1501;SCL:5;SRVR:SG2PR01MB2141;H:SG2PR01MB2141.apcprd01.prod.exchangelabs.com;FPR:;SPF:None;LANG:en;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zqiOX7tmbR3c711i0VHu4klJli+HV9DANFJAIV1OCrpStjRww0ItvTsoAwZxepCgAsHadQLGZ4WyBpAlOJkZpqUYOpg/pNzOS+ZHc4x4IGsx6YipK8tuywlyRwuaHB+7GuBCuscc3lad6Uw6Bk+ODPpSzFmbIycBqOTwKsnK3rjoL96QJ0ZYWSrrxxSK9gnPBar1nWgi2JaWNVqyGbHnxYDvdS6eXt5vFoDUznaNmIZow47kuNZuvUouWvQJs5zHpdxWGpRWQ0MxqzhO7nEnlYngBq0adTKP8pRNiwotqxkBL8xIRrbGWZqO2JNmkoStCjXCYN2gssUtn4qO+Cu+zJkMtpID2qMXwzDDt3Zcy46G8HQfVFG/oESdSok8tHpjbCjBJYucyFU0yR9ciHNz4eLlbEw1JmaJMHksZcSzyOxiR3R7cP/5P2Kd0G7WjyCwd88etSo53T/ao9Y8eUFnwHRURlJUOC+mbnMM1q5Y4o/bUYeravOJ5+orK2WpiyvpQF6dGJZfLPSKCgKchUCgW5+D1zqGaDC4zwb9CL18uU5pIXidIpVtQzMMwJ+rMrAT0lvsKPU1lIcelhLBA8L8jUhpqSJfxlRkE8AGzrHVVFkxlRxdvCSJngrZjdjPqW38hpb/EbThFO6jaEtD7K13+nCJNV9U9Ym3VxLPLHLE5h4WLG8PcJsZO+9driHE1RsbHLQ8vqAIV40nozABXla/hACzmQ+LuLnpXSi49I2lgbRTgNMQ25V5zVsQzX8X2TPMzPzalYX/0jxysQS0Vn5WIpnkD1LpI19LJtiCV8MZcQc/VJe2WhLsZVgLqvxTuelkQfsEBVYQ4MP0ZYdJwXm/w15GTZU4UPfm63Z8UWg5e2LOqu+9z4iYHzp4mqyUfd0d
x-ms-exchange-antispam-messagedata: uhYTwKJiYRxc24QkeN9lS+6En/8Jfj/EPhh2FVeU0HcXiOeCOjQr8CVj1xe6f+YiM1+TdjjYiFvrxn0hjeMwSeT/Xi0SYzG80JBx6b9RwL/U4hnJ8qrqTEvaPJ/Sz4ZuYdtH13MdeknSoKmcx4GDPgMC0reyghHbYI3Nh2HvTbJHBa3B2dfVXYn3/9qcQUYBfyEIWk1ou0haZWOUkC3+iw==
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: teo-en-ming-corp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47157d19-d027-44d9-e5a9-08d7b1e1b79a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2020 06:38:50.1225
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b3f6ae-c453-4b93-aec9-f17508e5885c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: txhOkHHO5B6POo/l1K3PyOgFQ0t/NyU08ZEMNnK3A2v/3hrBWy7vxzLuFmjV5iuJdtl86xVCwwUpLaHO5VE74Ebs6gXw2oGpj6uGqDoiH+c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR01MB2141
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Subject: Teo En Ming's Manual for Setting Up Samba 4.11.6 and CentOS 8.1 (1=
911) Linux Server QEMU/KVM Virtual Machine as an Active Directory Domain Co=
ntroller (AD DC)=0A=
=0A=
Subject: Teo En Ming's Manual for Setting Up Samba 4.11.6 and CentOS 8.1 (1=
911) Linux Server QEMU/KVM Virtual Machine as an Active Directory Domain Co=
ntroller (AD DC)=0A=
=0A=
PUBLISHED 15 FEB 2020 SATURDAY, SINGAPORE, SINGAPORE, SINGAPORE=0A=
=0A=
This manual/guide is meant for small and medium businesses (SMB) which do n=
ot want to spend a lot of money on Windows Server 2016/2019 licensing.=0A=
=0A=
REFERENCE GUIDE=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
Guide: Setting up Samba as an Active Directory Domain Controller=0A=
=0A=
Link: https://wiki.samba.org/index.php/Setting_up_Samba_as_an_Active_Direct=
ory_Domain_Controller=0A=
=0A=
EXTREMELY DETAILED INSTRUCTIONS OF TEO EN MING'S MANUAL=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=0A=
=0A=
Starting CentOS 8.1 (1911) Linux Server QEMU/KVM Virtual Machine on Ubuntu =
18.04.3 LTS Desktop Host=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
Virtual Machine Manager (virt-manager) depends on libvirtd service.=0A=
=0A=
$ sudo systemctl start libvirtd.service=0A=
=0A=
Start the Virtual Machine Manager.=0A=
=0A=
$ sudo virt-manager=0A=
=0A=
Select the CentOS 8.1 QEMU/KVM virtual machine and click "Power on the virt=
ual machine".=0A=
=0A=
REFERENCE GUIDE=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
Guide: ENABLING HOST-GUEST NETWORKING WITH KVM, MACVLAN AND MACVTAP=0A=
=0A=
Link: https://www.furorteutonicus.eu/2013/08/04/enabling-host-guest-network=
ing-with-kvm-macvlan-and-macvtap/=0A=
=0A=
Still on the Ubuntu 18.04.3 LTS Desktop host.=0A=
=0A=
$ nano /home/teo-en-ming/macvlan.sh=0A=
=0A=
#!/bin/bash=0A=
=0A=
# Adapted by Teo En Ming on 14 Feb 2020 Friday (Valentine's Day in Singapor=
e).=0A=
 =0A=
# let host and guests talk to each other over macvlan=0A=
# configures a macvlan interface on the hypervisor=0A=
# run this on the hypervisor (e.g. in /etc/rc.local)=0A=
# made for IPv4; need modification for IPv6=0A=
# meant for a simple network setup with only eth0 or enp5s0 on the host,=0A=
# and a static (manual) ip config=0A=
# Original Author: Evert Mouw, 2013 (European Union)=0A=
 =0A=
#HWLINK=3Deth0=0A=
HWLINK=3Denp5s0=0A=
MACVLN=3Dmacvlan0=0A=
TESTHOST=3Dwww.google.com=0A=
 =0A=
# ------------=0A=
# wait for network availability=0A=
# ------------=0A=
 =0A=
# IPv4 pings only=0A=
=0A=
while ! ping -4 -q -c 1 $TESTHOST > /dev/null=0A=
do=0A=
    echo "$0: Cannot ping $TESTHOST, waiting another 5 secs..."=0A=
    sleep 5=0A=
done=0A=
 =0A=
# ------------=0A=
# get network config=0A=
# ------------=0A=
 =0A=
IP=3D$(ip address show dev $HWLINK | grep "inet " | awk '{print $2}')=0A=
NETWORK=3D$(ip -o route | grep $HWLINK | grep -v default | grep -v 169 | aw=
k '{print $1}')=0A=
GATEWAY=3D$(ip -o route | grep default | awk '{print $3}')=0A=
 =0A=
# ------------=0A=
# setting up $MACVLN interface=0A=
# ------------=0A=
 =0A=
ip link add link $HWLINK $MACVLN type macvlan mode bridge=0A=
ip address add $IP dev $MACVLN=0A=
ip link set dev $MACVLN up=0A=
 =0A=
# ------------=0A=
# routing table=0A=
# ------------=0A=
 =0A=
# empty routes=0A=
ip route flush dev $HWLINK=0A=
ip route flush dev $MACVLN=0A=
 =0A=
# add routes=0A=
ip route add $NETWORK dev $MACVLN metric 0=0A=
 =0A=
# add the default gateway=0A=
ip route add default via $GATEWAY=0A=
=0A=
=3D=3D=3DEND OF LINUX SHELL SCRIPT=3D=3D=3D=0A=
=0A=
$ sudo chmod +x /home/teo-en-ming/macvlan.sh=0A=
=0A=
$ sudo /home/teo-en-ming/macvlan.sh=0A=
=0A=
192.168.1.122 is the IP address (DHCP auto configuration) of the CentOS 8.1=
 Linux Server.=0A=
ssh into the CentOS 8.1 Linux Server.=0A=
=0A=
ssh teo-en-ming@192.168.1.122=0A=
=0A=
PREPARING THE INSTALLATION ON CENTOS 8.1 LINUX SERVER=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=0A=
=0A=
Setting hostname of CentOS 8.1 Linux Server.=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
# hostnamectl set-hostname dc1=0A=
=0A=
To see the hostname:=0A=
=0A=
# hostnamectl=0A=
=0A=
Output:=0A=
=0A=
   Static hostname: dc1=0A=
         Icon name: computer-vm=0A=
           Chassis: vm=0A=
        Machine ID: 668fdf5de7214d56be0ef8b65f7166e9=0A=
           Boot ID: 5691a1a2dacd41c4ab5871d25885e138=0A=
    Virtualization: kvm=0A=
  Operating System: CentOS Linux 8 (Core)=0A=
       CPE OS Name: cpe:/o:centos:centos:8=0A=
            Kernel: Linux 4.18.0-147.el8.x86_64=0A=
      Architecture: x86-64=0A=
=0A=
How to set static IP address 192.168.1.10 on CentOS 8.1 Linux Server=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
# cd /etc/sysconfig/network-scripts/=0A=
=0A=
# nano ifcfg-ens3=0A=
=0A=
TYPE=3D"Ethernet"=0A=
PROXY_METHOD=3D"none"=0A=
BROWSER_ONLY=3D"no"=0A=
BOOTPROTO=3D"static"=0A=
DEFROUTE=3D"yes"=0A=
IPV4_FAILURE_FATAL=3D"no"=0A=
IPV6INIT=3D"yes"=0A=
IPV6_AUTOCONF=3D"yes"=0A=
IPV6_DEFROUTE=3D"yes"=0A=
IPV6_FAILURE_FATAL=3D"no"=0A=
IPV6_ADDR_GEN_MODE=3D"stable-privacy"=0A=
NAME=3D"ens3"=0A=
UUID=3D"8e179c97-1388-48ee-a8be-d173ee3ff40c"=0A=
DEVICE=3D"ens3"=0A=
ONBOOT=3D"yes"=0A=
IPADDR=3D"192.168.1.10"=0A=
PREFIX=3D"24"=0A=
GATEWAY=3D"192.168.1.1"=0A=
DNS1=3D"8.8.8.8" =3D=3D=3D>>> (IF YOU USE THIS LINE, NETWORK MANAGER WILL A=
LWAYS OVERWRITE /etc/resolv.conf, which is undesirable)=0A=
=0A=
# reboot=0A=
=0A=
ssh into CentOS 8.1 Linux Server with static IP address 192.168.1.10.=0A=
=0A=
$ ssh teo-en-ming@192.168.1.10=0A=
=0A=
Check if Samba processes are running:=0A=
=0A=
# ps ax | egrep "samba|smbd|nmbd|winbindd"=0A=
=0A=
# nano /etc/hosts=0A=
=0A=
Contents of file:=0A=
=0A=
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdoma=
in4=0A=
::1         localhost localhost.localdomain localhost6 localhost6.localdoma=
in6=0A=
192.168.1.10	dc1.teo-en-ming.corp dc1=0A=
=0A=
Backup the original /etc/krb5.conf=0A=
=0A=
# mv /etc/krb5.conf /etc/krb5.conf.bak=0A=
=0A=
INSTALLING SAMBA 4.11.6 ON CENTOS 8.1 LINUX SERVER QEMU/KVM VIRTUAL MACHINE=
=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=0A=
=0A=
REFERENCE GUIDE=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
Guide: Build Samba from Source=0A=
=0A=
Link: https://wiki.samba.org/index.php/Build_Samba_from_Source=0A=
=0A=
Installing package dependencies before building Samba on CentOS 8.1 Linux S=
erver.=0A=
=0A=
# yum -y install dnf-plugins-core=0A=
=0A=
# yum config-manager --set-enabled PowerTools=0A=
=0A=
# yum install docbook-style-xsl gcc gdb gnutls-devel gpgme-devel jansson-de=
vel=0A=
# yum install keyutils-libs-devel krb5-workstation libacl-devel libaio-deve=
l =0A=
# yum install libarchive-devel libattr-devel libblkid-devel libtasn1 libtas=
n1-tools =0A=
# yum install libxml2-devel libxslt openldap-devel pam-devel perl =0A=
# yum install perl-ExtUtils-MakeMaker perl-Parse-Yapp popt-devel python3-cr=
yptography =0A=
# yum install python3-dns python3-gpg python36-devel readline-devel rpcgen =
systemd-devel =0A=
# yum install tar zlib-devel=0A=
=0A=
Compulsory Packages NOT installed at the moment:=0A=
=0A=
lmdb-devel=0A=
=0A=
Download Samba current stable release 4.11.6.=0A=
=0A=
# wget https://download.samba.org/pub/samba/stable/samba-4.11.6.tar.gz=0A=
=0A=
# tar -zxf samba-4.11.6.tar.gz=0A=
=0A=
# cd samba-4.11.6/=0A=
=0A=
# ./configure=0A=
=0A=
Output:=0A=
=0A=
Samba AD DC and --enable-selftest requires lmdb 0.9.16 or later=0A=
=0A=
# yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.n=
oarch.rpm=0A=
=0A=
# yum install lmdb-devel=0A=
=0A=
Run ./configure again.=0A=
=0A=
# ./configure=0A=
=0A=
Output:=0A=
=0A=
'configure' finished successfully (42.262s)=0A=
=0A=
Make full use of all 4 cores on my AMD Ryzen 3 3200G processor.=0A=
=0A=
# make -j 4=0A=
=0A=
Output:=0A=
=0A=
Waf: Leaving directory `/root/samba-4.11.6/bin/default'=0A=
'build' finished successfully (9m24.396s)=0A=
=0A=
# make install=0A=
=0A=
Output:=0A=
=0A=
Waf: Leaving directory `/root/samba-4.11.6/bin/default'=0A=
'install' finished successfully (2m58.171s)=0A=
=0A=
# nano /etc/profile=0A=
=0A=
Append the following line:=0A=
=0A=
export PATH=3D$PATH:/usr/local/samba/bin/:/usr/local/samba/sbin/=0A=
=0A=
PROVISIONING A SAMBA ACTIVE DIRECTORY DOMAIN CONTROLLER=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=0A=
=0A=
Provisioning Samba AD DC in Interactive Mode.=0A=
=0A=
The original intention was to use SAMBA_INTERNAL DNS backend.=0A=
=0A=
# samba-tool domain provision --use-rfc2307 --interactive=0A=
=0A=
Output:=0A=
=0A=
Realm [TEO-EN-MING.CORP]:  TEO-EN-MING.CORP=0A=
Domain [TEO-EN-MING]:  TEO-EN-MING=0A=
Server Role (dc, member, standalone) [dc]:  dc=0A=
DNS backend (SAMBA_INTERNAL, BIND9_FLATFILE, BIND9_DLZ, NONE) [SAMBA_INTERN=
AL]:  SAMBA_INTERNAL=0A=
DNS forwarder IP address (write 'none' to disable forwarding) [8.8.8.8]:  8=
.8.8.8=0A=
Administrator password: =0A=
Retype password: =0A=
INFO 2020-02-14 22:56:13,700 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2128: Looking up IPv4 addresses=0A=
WARNING 2020-02-14 22:56:13,702 pid:2609 /usr/local/samba/lib64/python3.6/s=
ite-packages/samba/provision/__init__.py #2134: More than one IPv4 address =
found. Using 192.168.1.10=0A=
INFO 2020-02-14 22:56:13,702 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2145: Looking up IPv6 addresses=0A=
WARNING 2020-02-14 22:56:13,702 pid:2609 /usr/local/samba/lib64/python3.6/s=
ite-packages/samba/provision/__init__.py #2150: More than one IPv6 address =
found. Using 2401:7400:c802:de67::14c2=0A=
INFO 2020-02-14 22:56:14,152 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2319: Setting up share.ldb=0A=
INFO 2020-02-14 22:56:14,595 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2323: Setting up secrets.ldb=0A=
INFO 2020-02-14 22:56:14,848 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2329: Setting up the registry=0A=
INFO 2020-02-14 22:56:16,031 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2332: Setting up the privileges data=
base=0A=
INFO 2020-02-14 22:56:16,721 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2335: Setting up idmap db=0A=
INFO 2020-02-14 22:56:17,155 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2342: Setting up SAM db=0A=
INFO 2020-02-14 22:56:17,263 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #898: Setting up sam.ldb partitions a=
nd settings=0A=
INFO 2020-02-14 22:56:17,266 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #910: Setting up sam.ldb rootDSE=0A=
INFO 2020-02-14 22:56:17,331 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1339: Pre-loading the Samba 4 and AD=
 schema=0A=
Unable to determine the DomainSID, can not enforce uniqueness constraint on=
 local domainSIDs=0A=
=0A=
INFO 2020-02-14 22:56:17,548 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1417: Adding DomainDN: DC=3Dteo-en-m=
ing,DC=3Dcorp=0A=
INFO 2020-02-14 22:56:17,646 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1449: Adding configuration container=
=0A=
INFO 2020-02-14 22:56:17,722 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1464: Setting up sam.ldb schema=0A=
INFO 2020-02-14 22:56:21,121 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1482: Setting up sam.ldb configurati=
on data=0A=
INFO 2020-02-14 22:56:21,263 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1523: Setting up display specifiers=
=0A=
INFO 2020-02-14 22:56:23,502 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1531: Modifying display specifiers a=
nd extended rights=0A=
INFO 2020-02-14 22:56:23,543 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1538: Adding users container=0A=
INFO 2020-02-14 22:56:23,545 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1544: Modifying users container=0A=
INFO 2020-02-14 22:56:23,547 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1547: Adding computers container=0A=
INFO 2020-02-14 22:56:23,549 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1553: Modifying computers container=
=0A=
INFO 2020-02-14 22:56:23,550 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1557: Setting up sam.ldb data=0A=
INFO 2020-02-14 22:56:23,695 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1587: Setting up well known security=
 principals=0A=
INFO 2020-02-14 22:56:23,760 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1601: Setting up sam.ldb users and g=
roups=0A=
INFO 2020-02-14 22:56:24,075 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1609: Setting up self join=0A=
Repacking database from v1 to v2 format (first record CN=3Dms-DS-Replicatio=
n-Notify-First-DSA-Delay,CN=3DSchema,CN=3DConfiguration,DC=3Dteo-en-ming,DC=
=3Dcorp)=0A=
Repack: re-packed 10000 records so far=0A=
Repacking database from v1 to v2 format (first record CN=3DinterSiteTranspo=
rt-Display,CN=3D405,CN=3DDisplaySpecifiers,CN=3DConfiguration,DC=3Dteo-en-m=
ing,DC=3Dcorp)=0A=
Repacking database from v1 to v2 format (first record CN=3D6bcd567f-8314-11=
d6-977b-00c04f613221,CN=3DOperations,CN=3DDomainUpdates,CN=3DSystem,DC=3Dte=
o-en-ming,DC=3Dcorp)=0A=
INFO 2020-02-14 22:56:27,001 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/sambadns.py #1138: Adding DNS accounts=0A=
INFO 2020-02-14 22:56:27,377 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/sambadns.py #1172: Creating CN=3DMicrosoftDNS,CN=
=3DSystem,DC=3Dteo-en-ming,DC=3Dcorp=0A=
INFO 2020-02-14 22:56:27,401 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/sambadns.py #1185: Creating DomainDnsZones and Fo=
restDnsZones partitions=0A=
INFO 2020-02-14 22:56:27,620 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/sambadns.py #1190: Populating DomainDnsZones and =
ForestDnsZones partitions=0A=
Repacking database from v1 to v2 format (first record DC=3Df.root-servers.n=
et,DC=3DRootDNSServers,CN=3DMicrosoftDNS,DC=3DDomainDnsZones,DC=3Dteo-en-mi=
ng,DC=3Dcorp)=0A=
Repacking database from v1 to v2 format (first record DC=3D_ldap._tcp.dc,DC=
=3D_msdcs.teo-en-ming.corp,CN=3DMicrosoftDNS,DC=3DForestDnsZones,DC=3Dteo-e=
n-ming,DC=3Dcorp)=0A=
INFO 2020-02-14 22:56:28,660 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2032: Setting up sam.ldb rootDSE mar=
king as synchronized=0A=
INFO 2020-02-14 22:56:28,734 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2037: Fixing provision GUIDs=0A=
INFO 2020-02-14 22:56:29,720 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2395: A Kerberos configuration suita=
ble for Samba AD has been generated at /usr/local/samba/private/krb5.conf=
=0A=
INFO 2020-02-14 22:56:29,720 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2396: Merge the contents of this fil=
e with your system krb5.conf or replace it with this one. Do not create a s=
ymlink!=0A=
INFO 2020-02-14 22:56:30,078 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2102: Setting up fake yp server sett=
ings=0A=
INFO 2020-02-14 22:56:30,277 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #491: Once the above files are instal=
led, your Samba AD server will be ready to use=0A=
INFO 2020-02-14 22:56:30,277 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #495: Server Role:           active d=
irectory domain controller=0A=
INFO 2020-02-14 22:56:30,278 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #496: Hostname:              dc1=0A=
INFO 2020-02-14 22:56:30,278 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #497: NetBIOS Domain:        TEO-EN-M=
ING=0A=
INFO 2020-02-14 22:56:30,278 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #498: DNS Domain:            teo-en-m=
ing.corp=0A=
INFO 2020-02-14 22:56:30,278 pid:2609 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #499: DOMAIN SID:            S-1-5-21=
-3028196010-72872391-2123559056=0A=
=0A=
Configuring the DNS Resolver. Network Manager will keep overwriting /etc/re=
solv.conf. This problem will be resolved later.=0A=
=0A=
# nano /etc/resolv.conf=0A=
=0A=
=0A=
Contents of file:=0A=
=0A=
search teo-en-ming.corp=0A=
nameserver 192.168.1.10=0A=
=0A=
REFERENCE GUIDE=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
Guide: Managing the Samba AD DC Service Using Systemd=0A=
=0A=
Link: https://wiki.samba.org/index.php/Managing_the_Samba_AD_DC_Service_Usi=
ng_Systemd=0A=
=0A=
# systemctl mask smbd nmbd winbind=0A=
=0A=
# systemctl disable smbd nmbd winbind=0A=
=0A=
# nano /etc/systemd/system/samba-ad-dc.service=0A=
=0A=
Contents of file:=0A=
=0A=
[Unit]=0A=
Description=3DSamba Active Directory Domain Controller=0A=
After=3Dnetwork.target remote-fs.target nss-lookup.target=0A=
=0A=
[Service]=0A=
Type=3Dforking=0A=
ExecStart=3D/usr/local/samba/sbin/samba -D=0A=
PIDFile=3D/usr/local/samba/var/run/samba.pid=0A=
ExecReload=3D/bin/kill -HUP $MAINPID=0A=
=0A=
[Install]=0A=
WantedBy=3Dmulti-user.target=0A=
=0A=
=0A=
# systemctl daemon-reload=0A=
=0A=
# systemctl enable samba-ad-dc=0A=
=0A=
# systemctl start samba-ad-dc=0A=
=0A=
Output:=0A=
=0A=
Job for samba-ad-dc.service failed because the control process exited with =
error code.=0A=
See "systemctl status samba-ad-dc.service" and "journalctl -xe" for details=
.=0A=
=0A=
The SAMBA AD DC service cannot start because SELINUX is enabled on CentOS 8=
.1.=0A=
We will see later.=0A=
=0A=
# systemctl status samba-ad-dc=0A=
=0A=
Output:=0A=
=0A=
=1B$B!|=1B(B samba-ad-dc.service - Samba Active Directory Domain Controller=
=0A=
   Loaded: loaded (/etc/systemd/system/samba-ad-dc.service; enabled; vendor=
 preset: disabled)=0A=
   Active: failed (Result: exit-code) since Sat 2020-02-15 08:39:58 +08; 46=
s ago=0A=
  Process: 6967 ExecStart=3D/usr/local/samba/sbin/samba -D (code=3Dexited, =
status=3D203/EXEC)=0A=
 Main PID: 1595 (code=3Dexited, status=3D203/EXEC)=0A=
=0A=
Feb 15 08:39:58 dc1 systemd[1]: Starting Samba Active Directory Domain Cont=
roller...=0A=
Feb 15 08:39:58 dc1 systemd[1]: samba-ad-dc.service: Control process exited=
, code=3Dexited status=3D203=0A=
Feb 15 08:39:58 dc1 systemd[1]: samba-ad-dc.service: Failed with result 'ex=
it-code'.=0A=
Feb 15 08:39:58 dc1 systemd[1]: Failed to start Samba Active Directory Doma=
in Controller.=0A=
=0A=
SAMBA AD DC service cannot start because SELINUX is enabled on CentOS 8.1.=
=0A=
We will see later.=0A=
=0A=
=0A=
# reboot=0A=
=0A=
Start Samba AD DC manually.=0A=
=0A=
# samba -D=0A=
=0A=
Create a reverse zone in Samba Internal DNS Backend.=0A=
=0A=
# samba-tool dns zonecreate 192.168.1.10 1.168.192.in-addr.arpa -U administ=
rator=0A=
=0A=
Output:=0A=
=0A=
Password for [TEO-EN-MING\administrator]:=0A=
Zone 1.168.192.in-addr.arpa created successfully=0A=
=0A=
Configuring Kerberos=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
cp /usr/local/samba/private/krb5.conf /etc/krb5.conf=0A=
=0A=
Starting Samba AD DC Manually.=0A=
=0A=
# samba -D=0A=
=0A=
Verifying the File Server.=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=0A=
=0A=
$ smbclient -L localhost -U%=0A=
=0A=
Output:=0A=
=0A=
	Sharename       Type      Comment=0A=
	---------       ----      -------=0A=
	sysvol          Disk      =0A=
	netlogon        Disk      =0A=
	IPC$            IPC       IPC Service (Samba 4.11.6)=0A=
SMB1 disabled -- no workgroup available=0A=
=0A=
$ smbclient //localhost/netlogon -UAdministrator -c 'ls'=0A=
=0A=
Output:=0A=
=0A=
Enter TEO-EN-MING\Administrator's password: =0A=
  .                                   D        0  Fri Feb 14 22:56:17 2020=
=0A=
  ..                                  D        0  Fri Feb 14 22:56:24 2020=
=0A=
=0A=
		17811456 blocks of size 1024. 12025652 blocks available=0A=
=0A=
Verifying DNS (Failed)=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
# killall dnsmasq=0A=
=0A=
$ host -t SRV _ldap._tcp.teo-en-ming.corp.=0A=
=0A=
Output: =0A=
=0A=
Host _ldap._tcp.teo-en-ming.corp. not found: 3(NXDOMAIN)=0A=
=0A=
=0A=
$ host -t SRV _kerberos._udp.teo-en-ming.corp.=0A=
=0A=
Output: =0A=
=0A=
Host _kerberos._udp.teo-en-ming.corp. not found: 3(NXDOMAIN)=0A=
=0A=
$ host -t A dc1.teo-en-ming.corp.=0A=
=0A=
Output:=0A=
=0A=
Host dc1.teo-en-ming.corp. not found: 3(NXDOMAIN)=0A=
=0A=
I am unable to find the above DNS records because Network Manager keeps ove=
rwriting /etc/resolv.conf=0A=
As a result, I am always looking up the WRONG DNS server.=0A=
=0A=
Verifying Kerberos=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
$ kinit administrator=0A=
=0A=
Output:=0A=
=0A=
kinit: Cannot find KDC for realm "TEO-EN-MING.CORP" while getting initial c=
redentials=0A=
=0A=
The above problem is also due to Network Manager keeps overwriting /etc/res=
olv.conf.=0A=
As a result, I am always looking up the WRONG DNS server.=0A=
=0A=
TROUBLESHOOTING: DISABLE SELINUX ON CENTOS 8.1=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
$ sestatus=0A=
=0A=
Output:=0A=
=0A=
SELinux status:                 enabled=0A=
SELinuxfs mount:                /sys/fs/selinux=0A=
SELinux root directory:         /etc/selinux=0A=
Loaded policy name:             targeted=0A=
Current mode:                   enforcing=0A=
Mode from config file:          enforcing=0A=
Policy MLS status:              enabled=0A=
Policy deny_unknown status:     allowed=0A=
Memory protection checking:     actual (secure)=0A=
Max kernel policy version:      31=0A=
=0A=
# nano /etc/sysconfig/selinux=0A=
=0A=
Change from SELINUX=3Denforcing to SELINUX=3Ddisabled=0A=
=0A=
# reboot=0A=
=0A=
$ sestatus=0A=
=0A=
SELinux status:                 disabled=0A=
=0A=
After disabling SELINUX, now we can start Samba AD DC successfully.=0A=
=0A=
# systemctl status samba-ad-dc=0A=
=0A=
Output:=0A=
=0A=
=1B$B!|=1B(B samba-ad-dc.service - Samba Active Directory Domain Controller=
=0A=
   Loaded: loaded (/etc/systemd/system/samba-ad-dc.service; enabled; vendor=
 preset: disabled)=0A=
   Active: active (running) since Sat 2020-02-15 08:50:22 +08; 1min 0s ago=
=0A=
  Process: 1084 ExecStart=3D/usr/local/samba/sbin/samba -D (code=3Dexited, =
status=3D0/SUCCESS)=0A=
 Main PID: 1131 (samba)=0A=
    Tasks: 44 (limit: 23972)=0A=
   Memory: 261.8M=0A=
   CGroup: /system.slice/samba-ad-dc.service=0A=
           =1B$B('(!=1B(B1131 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1375 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1376 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1377 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1379 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1380 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1387 /usr/local/samba/sbin/smbd -D --option=3Dserv=
er role check:inhibit=3Dyes --foreground=0A=
           =1B$B('(!=1B(B1389 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1391 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1392 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1393 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1396 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1398 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1399 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1403 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1404 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1407 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1408 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1409 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1411 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1412 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1413 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1415 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1416 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1418 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1419 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1420 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1422 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1423 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1424 /usr/local/samba/sbin/winbindd -D --option=3D=
server role check:inhibit=3Dyes --foreground=0A=
           =1B$B('(!=1B(B1426 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1427 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1429 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1464 /usr/local/samba/sbin/smbd -D --option=3Dserv=
er role check:inhibit=3Dyes --foreground=0A=
           =1B$B('(!=1B(B1465 /usr/local/samba/sbin/smbd -D --option=3Dserv=
er role check:inhibit=3Dyes --foreground=0A=
           =1B$B('(!=1B(B1469 /usr/local/samba/sbin/smbd -D --option=3Dserv=
er role check:inhibit=3Dyes --foreground=0A=
           =1B$B('(!=1B(B1490 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1492 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1493 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1495 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1496 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1498 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B1499 /usr/local/samba/sbin/samba -D=0A=
           =1B$B(&(!=1B(B1501 /usr/local/samba/sbin/samba -D=0A=
=0A=
Feb 15 08:50:25 dc1 samba[1131]: [2020/02/15 08:50:25.778777,  0] ../../sou=
rce4/smbd/process_prefork.c:512(prefork_child_pipe_handler)=0A=
Feb 15 08:50:25 dc1 samba[1131]:   prefork_child_pipe_handler: Parent 1131,=
 Child 1406 exited with status 0=0A=
Feb 15 08:50:27 dc1 smbd[1387]: [2020/02/15 08:50:27.634592,  0] ../../lib/=
util/become_daemon.c:136(daemon_ready)=0A=
Feb 15 08:50:27 dc1 smbd[1387]:   daemon_ready: daemon 'smbd' finished star=
ting up and ready to serve connections=0A=
Feb 15 08:50:27 dc1 winbindd[1424]: [2020/02/15 08:50:27.761081,  0] ../../=
source3/winbindd/winbindd_cache.c:3166(initialize_winbindd_cache)=0A=
Feb 15 08:50:27 dc1 winbindd[1424]:   initialize_winbindd_cache: clearing c=
ache and re-creating with version number 2=0A=
Feb 15 08:50:27 dc1 winbindd[1424]: [2020/02/15 08:50:27.770049,  0] ../../=
lib/util/become_daemon.c:136(daemon_ready)=0A=
Feb 15 08:50:27 dc1 winbindd[1424]:   daemon_ready: daemon 'winbindd' finis=
hed starting up and ready to serve connections=0A=
Feb 15 08:50:27 dc1 samba[1426]: [2020/02/15 08:50:27.870385,  0] ../../lib=
/util/util_runcmd.c:352(samba_runcmd_io_handler)=0A=
Feb 15 08:50:27 dc1 samba[1426]:   /usr/local/samba/sbin/samba_dnsupdate: W=
ARNING: no network interfaces found=0A=
=0A=
We need to kill dnsmasq so that Samba's internal DNS server can start.=0A=
=0A=
# killall dnsmasq=0A=
=0A=
# systemctl restart samba-ad-dc=0A=
=0A=
# systemctl status samba-ad-dc=0A=
=0A=
=1B$B!|=1B(B samba-ad-dc.service - Samba Active Directory Domain Controller=
=0A=
   Loaded: loaded (/etc/systemd/system/samba-ad-dc.service; enabled; vendor=
 preset: disabled)=0A=
   Active: active (running) since Sat 2020-02-15 08:53:28 +08; 21s ago=0A=
  Process: 2512 ExecStart=3D/usr/local/samba/sbin/samba -D (code=3Dexited, =
status=3D0/SUCCESS)=0A=
 Main PID: 2514 (samba)=0A=
    Tasks: 58 (limit: 23972)=0A=
   Memory: 215.6M=0A=
   CGroup: /system.slice/samba-ad-dc.service=0A=
           =1B$B('(!=1B(B2514 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2516 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2517 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2518 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2519 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2520 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2521 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2522 /usr/local/samba/sbin/smbd -D --option=3Dserv=
er role check:inhibit=3Dyes --foreground=0A=
           =1B$B('(!=1B(B2523 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2524 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2525 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2526 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2527 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2528 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2529 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2530 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2531 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2532 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2533 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2534 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2535 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2536 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2537 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2538 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2539 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2540 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2541 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2542 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2543 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2544 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2545 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2546 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2547 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2548 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2549 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2550 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2551 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2552 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2553 /usr/local/samba/sbin/winbindd -D --option=3D=
server role check:inhibit=3Dyes --foreground=0A=
           =1B$B('(!=1B(B2554 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2555 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2556 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2557 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2558 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2559 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2560 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2562 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2569 /usr/local/samba/sbin/smbd -D --option=3Dserv=
er role check:inhibit=3Dyes --foreground=0A=
           =1B$B('(!=1B(B2570 /usr/local/samba/sbin/smbd -D --option=3Dserv=
er role check:inhibit=3Dyes --foreground=0A=
           =1B$B('(!=1B(B2571 /usr/local/samba/sbin/smbd -D --option=3Dserv=
er role check:inhibit=3Dyes --foreground=0A=
           =1B$B('(!=1B(B2572 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2573 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2574 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2575 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2576 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2577 /usr/local/samba/sbin/samba -D=0A=
           =1B$B('(!=1B(B2578 /usr/local/samba/sbin/samba -D=0A=
           =1B$B(&(!=1B(B2579 /usr/local/samba/sbin/samba -D=0A=
=0A=
Feb 15 08:53:38 dc1 samba[2556]: [2020/02/15 08:53:38.742774,  0] ../../lib=
/util/util_runcmd.c:352(samba_runcmd_io_handler)=0A=
Feb 15 08:53:38 dc1 samba[2556]:   /usr/local/samba/sbin/samba_dnsupdate:  =
 File "/usr/local/samba/lib64/python3.6/site-packages/samba/netcmd/dns.py",=
 line 945, in run=0A=
Feb 15 08:53:38 dc1 samba[2556]: [2020/02/15 08:53:38.742787,  0] ../../lib=
/util/util_runcmd.c:352(samba_runcmd_io_handler)=0A=
Feb 15 08:53:38 dc1 samba[2556]:   /usr/local/samba/sbin/samba_dnsupdate:  =
   raise e=0A=
Feb 15 08:53:38 dc1 samba[2556]: [2020/02/15 08:53:38.742800,  0] ../../lib=
/util/util_runcmd.c:352(samba_runcmd_io_handler)=0A=
Feb 15 08:53:38 dc1 samba[2556]:   /usr/local/samba/sbin/samba_dnsupdate:  =
 File "/usr/local/samba/lib64/python3.6/site-packages/samba/netcmd/dns.py",=
 line 941, in run=0A=
Feb 15 08:53:38 dc1 samba[2556]: [2020/02/15 08:53:38.742813,  0] ../../lib=
/util/util_runcmd.c:352(samba_runcmd_io_handler)=0A=
Feb 15 08:53:38 dc1 samba[2556]:   /usr/local/samba/sbin/samba_dnsupdate:  =
   0, server, zone, name, add_rec_buf, None)=0A=
Feb 15 08:53:38 dc1 samba[2556]: [2020/02/15 08:53:38.767521,  0] ../../sou=
rce4/dsdb/dns/dns_update.c:331(dnsupdate_nameupdate_done)=0A=
Feb 15 08:53:38 dc1 samba[2556]:   dnsupdate_nameupdate_done: Failed DNS up=
date with exit code 39=0A=
=0A=
=0A=
Testing your Samba AD DC=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
# killall dnsmasq=0A=
=0A=
# systemctl restart samba-ad-dc=0A=
=0A=
Verifying the File Server=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=0A=
=0A=
$ smbclient -L localhost -U%=0A=
=0A=
Output:=0A=
=0A=
=0A=
	Sharename       Type      Comment=0A=
	---------       ----      -------=0A=
	sysvol          Disk      =0A=
	netlogon        Disk      =0A=
	IPC$            IPC       IPC Service (Samba 4.11.6)=0A=
SMB1 disabled -- no workgroup available=0A=
=0A=
$ smbclient //localhost/netlogon -UAdministrator -c 'ls'=0A=
=0A=
Output:=0A=
=0A=
Enter TEO-EN-MING\Administrator's password: =0A=
  .                                   D        0  Fri Feb 14 22:56:17 2020=
=0A=
  ..                                  D        0  Fri Feb 14 22:56:24 2020=
=0A=
=0A=
		17811456 blocks of size 1024. 12018876 blocks available=0A=
=0A=
Verifying DNS (Failed again)=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=0A=
=0A=
$ host -t SRV _ldap._tcp.teo-en-ming.corp.=0A=
=0A=
Output:=0A=
=0A=
Host _ldap._tcp.teo-en-ming.corp. not found: 3(NXDOMAIN)=0A=
=0A=
Unable to find above DNS record because Network Manager is always overwriti=
ng /etc/resolv.conf=0A=
As a result, I am always looking up the WRONG DNS server.=0A=
=0A=
# systemctl stop samba-ad-dc=0A=
=0A=
TROUBLESHOOTING AGAIN=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
Re-provisioning the Samba AD DC, using Samba Internal DNS Backend again.=0A=
=0A=
# samba-tool domain provision --use-rfc2307 --interactive=0A=
=0A=
Output:=0A=
=0A=
Realm [TEO-EN-MING.CORP]:  =0A=
Domain [TEO-EN-MING]:  =0A=
Server Role (dc, member, standalone) [dc]:  =0A=
DNS backend (SAMBA_INTERNAL, BIND9_FLATFILE, BIND9_DLZ, NONE) [SAMBA_INTERN=
AL]:  =0A=
DNS forwarder IP address (write 'none' to disable forwarding) [8.8.8.8]:  =
=0A=
Administrator password: =0A=
Retype password: =0A=
INFO 2020-02-15 09:01:10,638 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2128: Looking up IPv4 addresses=0A=
WARNING 2020-02-15 09:01:10,638 pid:2672 /usr/local/samba/lib64/python3.6/s=
ite-packages/samba/provision/__init__.py #2134: More than one IPv4 address =
found. Using 192.168.1.10=0A=
INFO 2020-02-15 09:01:10,638 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2145: Looking up IPv6 addresses=0A=
WARNING 2020-02-15 09:01:10,639 pid:2672 /usr/local/samba/lib64/python3.6/s=
ite-packages/samba/provision/__init__.py #2150: More than one IPv6 address =
found. Using 2401:7400:c802:de67::14c2=0A=
INFO 2020-02-15 09:01:11,057 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2323: Setting up secrets.ldb=0A=
INFO 2020-02-15 09:01:11,436 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2329: Setting up the registry=0A=
INFO 2020-02-15 09:01:11,620 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2332: Setting up the privileges data=
base=0A=
INFO 2020-02-15 09:01:12,200 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2335: Setting up idmap db=0A=
INFO 2020-02-15 09:01:12,667 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2342: Setting up SAM db=0A=
INFO 2020-02-15 09:01:12,817 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #898: Setting up sam.ldb partitions a=
nd settings=0A=
INFO 2020-02-15 09:01:12,820 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #910: Setting up sam.ldb rootDSE=0A=
INFO 2020-02-15 09:01:12,893 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1339: Pre-loading the Samba 4 and AD=
 schema=0A=
Unable to determine the DomainSID, can not enforce uniqueness constraint on=
 local domainSIDs=0A=
=0A=
INFO 2020-02-15 09:01:13,093 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1417: Adding DomainDN: DC=3Dteo-en-m=
ing,DC=3Dcorp=0A=
INFO 2020-02-15 09:01:13,201 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1449: Adding configuration container=
=0A=
INFO 2020-02-15 09:01:13,342 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1464: Setting up sam.ldb schema=0A=
INFO 2020-02-15 09:01:16,649 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1482: Setting up sam.ldb configurati=
on data=0A=
INFO 2020-02-15 09:01:16,794 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1523: Setting up display specifiers=
=0A=
INFO 2020-02-15 09:01:19,013 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1531: Modifying display specifiers a=
nd extended rights=0A=
INFO 2020-02-15 09:01:19,053 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1538: Adding users container=0A=
INFO 2020-02-15 09:01:19,056 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1544: Modifying users container=0A=
INFO 2020-02-15 09:01:19,057 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1547: Adding computers container=0A=
INFO 2020-02-15 09:01:19,060 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1553: Modifying computers container=
=0A=
INFO 2020-02-15 09:01:19,061 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1557: Setting up sam.ldb data=0A=
INFO 2020-02-15 09:01:19,199 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1587: Setting up well known security=
 principals=0A=
INFO 2020-02-15 09:01:19,261 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1601: Setting up sam.ldb users and g=
roups=0A=
INFO 2020-02-15 09:01:19,564 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1609: Setting up self join=0A=
Repacking database from v1 to v2 format (first record CN=3DMSMQ-Sign-Certif=
icates-Mig,CN=3DSchema,CN=3DConfiguration,DC=3Dteo-en-ming,DC=3Dcorp)=0A=
Repack: re-packed 10000 records so far=0A=
Repacking database from v1 to v2 format (first record CN=3DlostAndFound-Dis=
play,CN=3D411,CN=3DDisplaySpecifiers,CN=3DConfiguration,DC=3Dteo-en-ming,DC=
=3Dcorp)=0A=
Repacking database from v1 to v2 format (first record CN=3D5e1574f6-55df-49=
3e-a671-aaeffca6a100,CN=3DOperations,CN=3DDomainUpdates,CN=3DSystem,DC=3Dte=
o-en-ming,DC=3Dcorp)=0A=
INFO 2020-02-15 09:01:21,879 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/sambadns.py #1138: Adding DNS accounts=0A=
INFO 2020-02-15 09:01:22,122 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/sambadns.py #1172: Creating CN=3DMicrosoftDNS,CN=
=3DSystem,DC=3Dteo-en-ming,DC=3Dcorp=0A=
INFO 2020-02-15 09:01:22,144 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/sambadns.py #1185: Creating DomainDnsZones and Fo=
restDnsZones partitions=0A=
INFO 2020-02-15 09:01:22,393 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/sambadns.py #1190: Populating DomainDnsZones and =
ForestDnsZones partitions=0A=
Repacking database from v1 to v2 format (first record DC=3Dl.root-servers.n=
et,DC=3DRootDNSServers,CN=3DMicrosoftDNS,DC=3DDomainDnsZones,DC=3Dteo-en-mi=
ng,DC=3Dcorp)=0A=
Repacking database from v1 to v2 format (first record DC=3Dgc,DC=3D_msdcs.t=
eo-en-ming.corp,CN=3DMicrosoftDNS,DC=3DForestDnsZones,DC=3Dteo-en-ming,DC=
=3Dcorp)=0A=
INFO 2020-02-15 09:01:23,163 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2032: Setting up sam.ldb rootDSE mar=
king as synchronized=0A=
INFO 2020-02-15 09:01:23,213 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2037: Fixing provision GUIDs=0A=
INFO 2020-02-15 09:01:24,265 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2395: A Kerberos configuration suita=
ble for Samba AD has been generated at /usr/local/samba/private/krb5.conf=
=0A=
INFO 2020-02-15 09:01:24,265 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2396: Merge the contents of this fil=
e with your system krb5.conf or replace it with this one. Do not create a s=
ymlink!=0A=
INFO 2020-02-15 09:01:24,581 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2102: Setting up fake yp server sett=
ings=0A=
INFO 2020-02-15 09:01:24,772 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #491: Once the above files are instal=
led, your Samba AD server will be ready to use=0A=
INFO 2020-02-15 09:01:24,772 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #495: Server Role:           active d=
irectory domain controller=0A=
INFO 2020-02-15 09:01:24,772 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #496: Hostname:              dc1=0A=
INFO 2020-02-15 09:01:24,773 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #497: NetBIOS Domain:        TEO-EN-M=
ING=0A=
INFO 2020-02-15 09:01:24,773 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #498: DNS Domain:            teo-en-m=
ing.corp=0A=
INFO 2020-02-15 09:01:24,773 pid:2672 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #499: DOMAIN SID:            S-1-5-21=
-3427788993-2190856266-1509719656=0A=
=0A=
# systemctl start samba-ad-dc=0A=
=0A=
Verifying DNS (Failed again)=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
host -t SRV _ldap._tcp.teo-en-ming.corp.=0A=
=0A=
Output:=0A=
=0A=
Host _ldap._tcp.teo-en-ming.corp. not found: 3(NXDOMAIN)=0A=
=0A=
Unable to find above DNS record because Network Manager is always overwriti=
ng /etc/resolv.conf=0A=
As a result, I am always looking up the WRONG DNS server.=0A=
=0A=
Installing BIND DNS Server and Using it as the DNS Backend for Samba=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
# yum install bind=0A=
=0A=
# systemctl stop samba-ad-dc=0A=
=0A=
We are going to use BIND9 as the Samba DNS backend this time.=0A=
I changed my mind. I decided not to use Samba's Internal DNS backend.=0A=
=0A=
# samba-tool domain provision --use-rfc2307 --interactive=0A=
=0A=
Output:=0A=
=0A=
Realm [TEO-EN-MING.CORP]:  =0A=
Domain [TEO-EN-MING]:  =0A=
Server Role (dc, member, standalone) [dc]:  =0A=
DNS backend (SAMBA_INTERNAL, BIND9_FLATFILE, BIND9_DLZ, NONE) [SAMBA_INTERN=
AL]:  BIND9_DLZ=0A=
Administrator password: =0A=
Retype password: =0A=
INFO 2020-02-15 09:13:53,976 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2128: Looking up IPv4 addresses=0A=
WARNING 2020-02-15 09:13:53,976 pid:3479 /usr/local/samba/lib64/python3.6/s=
ite-packages/samba/provision/__init__.py #2134: More than one IPv4 address =
found. Using 192.168.1.10=0A=
INFO 2020-02-15 09:13:53,976 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2145: Looking up IPv6 addresses=0A=
WARNING 2020-02-15 09:13:53,977 pid:3479 /usr/local/samba/lib64/python3.6/s=
ite-packages/samba/provision/__init__.py #2150: More than one IPv6 address =
found. Using 2401:7400:c802:de67::14c2=0A=
INFO 2020-02-15 09:13:54,381 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2323: Setting up secrets.ldb=0A=
INFO 2020-02-15 09:13:54,704 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2329: Setting up the registry=0A=
INFO 2020-02-15 09:13:54,888 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2332: Setting up the privileges data=
base=0A=
INFO 2020-02-15 09:13:55,478 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2335: Setting up idmap db=0A=
INFO 2020-02-15 09:13:55,819 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2342: Setting up SAM db=0A=
INFO 2020-02-15 09:13:55,886 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #898: Setting up sam.ldb partitions a=
nd settings=0A=
INFO 2020-02-15 09:13:55,888 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #910: Setting up sam.ldb rootDSE=0A=
INFO 2020-02-15 09:13:55,945 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1339: Pre-loading the Samba 4 and AD=
 schema=0A=
Unable to determine the DomainSID, can not enforce uniqueness constraint on=
 local domainSIDs=0A=
=0A=
INFO 2020-02-15 09:13:56,187 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1417: Adding DomainDN: DC=3Dteo-en-m=
ing,DC=3Dcorp=0A=
INFO 2020-02-15 09:13:56,362 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1449: Adding configuration container=
=0A=
INFO 2020-02-15 09:13:56,518 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1464: Setting up sam.ldb schema=0A=
INFO 2020-02-15 09:13:59,846 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1482: Setting up sam.ldb configurati=
on data=0A=
INFO 2020-02-15 09:13:59,991 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1523: Setting up display specifiers=
=0A=
INFO 2020-02-15 09:14:02,238 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1531: Modifying display specifiers a=
nd extended rights=0A=
INFO 2020-02-15 09:14:02,279 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1538: Adding users container=0A=
INFO 2020-02-15 09:14:02,280 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1544: Modifying users container=0A=
INFO 2020-02-15 09:14:02,282 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1547: Adding computers container=0A=
INFO 2020-02-15 09:14:02,283 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1553: Modifying computers container=
=0A=
INFO 2020-02-15 09:14:02,284 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1557: Setting up sam.ldb data=0A=
INFO 2020-02-15 09:14:02,425 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1587: Setting up well known security=
 principals=0A=
INFO 2020-02-15 09:14:02,489 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1601: Setting up sam.ldb users and g=
roups=0A=
INFO 2020-02-15 09:14:02,777 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1609: Setting up self join=0A=
Repacking database from v1 to v2 format (first record CN=3DMS-TS-Property02=
,CN=3DSchema,CN=3DConfiguration,DC=3Dteo-en-ming,DC=3Dcorp)=0A=
Repack: re-packed 10000 records so far=0A=
Repacking database from v1 to v2 format (first record CN=3DlocalPolicy-Disp=
lay,CN=3DC0A,CN=3DDisplaySpecifiers,CN=3DConfiguration,DC=3Dteo-en-ming,DC=
=3Dcorp)=0A=
Repacking database from v1 to v2 format (first record CN=3DPolicyType,CN=3D=
WMIPolicy,CN=3DSystem,DC=3Dteo-en-ming,DC=3Dcorp)=0A=
INFO 2020-02-15 09:14:05,299 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/sambadns.py #1138: Adding DNS accounts=0A=
INFO 2020-02-15 09:14:05,558 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/sambadns.py #1172: Creating CN=3DMicrosoftDNS,CN=
=3DSystem,DC=3Dteo-en-ming,DC=3Dcorp=0A=
INFO 2020-02-15 09:14:05,587 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/sambadns.py #1185: Creating DomainDnsZones and Fo=
restDnsZones partitions=0A=
INFO 2020-02-15 09:14:05,778 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/sambadns.py #1190: Populating DomainDnsZones and =
ForestDnsZones partitions=0A=
Repacking database from v1 to v2 format (first record DC=3D_ldap._tcp.Domai=
nDnsZones,DC=3Dteo-en-ming.corp,CN=3DMicrosoftDNS,DC=3DDomainDnsZones,DC=3D=
teo-en-ming,DC=3Dcorp)=0A=
Repacking database from v1 to v2 format (first record CN=3DMicrosoftDNS,DC=
=3DForestDnsZones,DC=3Dteo-en-ming,DC=3Dcorp)=0A=
INFO 2020-02-15 09:14:07,207 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/sambadns.py #1272: See /usr/local/samba/bind-dns/=
named.conf for an example configuration include file for BIND=0A=
INFO 2020-02-15 09:14:07,207 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/sambadns.py #1274: and /usr/local/samba/bind-dns/=
named.txt for further documentation required for secure DNS updates=0A=
INFO 2020-02-15 09:14:07,333 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2032: Setting up sam.ldb rootDSE mar=
king as synchronized=0A=
INFO 2020-02-15 09:14:07,383 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2037: Fixing provision GUIDs=0A=
INFO 2020-02-15 09:14:08,576 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2395: A Kerberos configuration suita=
ble for Samba AD has been generated at /usr/local/samba/private/krb5.conf=
=0A=
INFO 2020-02-15 09:14:08,576 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2396: Merge the contents of this fil=
e with your system krb5.conf or replace it with this one. Do not create a s=
ymlink!=0A=
INFO 2020-02-15 09:14:09,009 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2102: Setting up fake yp server sett=
ings=0A=
INFO 2020-02-15 09:14:09,200 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #491: Once the above files are instal=
led, your Samba AD server will be ready to use=0A=
INFO 2020-02-15 09:14:09,201 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #495: Server Role:           active d=
irectory domain controller=0A=
INFO 2020-02-15 09:14:09,201 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #496: Hostname:              dc1=0A=
INFO 2020-02-15 09:14:09,201 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #497: NetBIOS Domain:        TEO-EN-M=
ING=0A=
INFO 2020-02-15 09:14:09,201 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #498: DNS Domain:            teo-en-m=
ing.corp=0A=
INFO 2020-02-15 09:14:09,201 pid:3479 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #499: DOMAIN SID:            S-1-5-21=
-3153339276-3256266220-4030185391=0A=
=0A=
# nano /etc/named.conf=0A=
=0A=
Append the following line:=0A=
=0A=
include "/usr/local/samba/bind-dns/named.conf";=0A=
=0A=
# named -v=0A=
=0A=
Output:=0A=
=0A=
BIND 9.11.4-P2-RedHat-9.11.4-26.P2.el8 (Extended Support Version) <id:7107d=
eb>=0A=
=0A=
# nano /usr/local/samba/bind-dns/named.conf=0A=
=0A=
Contents of file:=0A=
=0A=
# This DNS configuration is for BIND 9.8.0 or later with dlz_dlopen support=
.=0A=
#=0A=
# This file should be included in your main BIND configuration file=0A=
#=0A=
# For example with=0A=
# include "/usr/local/samba/bind-dns/named.conf";=0A=
=0A=
#=0A=
# This configures dynamically loadable zones (DLZ) from AD schema=0A=
# Uncomment only single database line, depending on your BIND version=0A=
#=0A=
dlz "AD DNS Zone" {=0A=
    # For BIND 9.8.x=0A=
    # database "dlopen /usr/local/samba/lib/bind9/dlz_bind9.so";=0A=
=0A=
    # For BIND 9.9.x=0A=
    # database "dlopen /usr/local/samba/lib/bind9/dlz_bind9_9.so";=0A=
=0A=
    # For BIND 9.10.x=0A=
    # database "dlopen /usr/local/samba/lib/bind9/dlz_bind9_10.so";=0A=
=0A=
    # For BIND 9.11.x=0A=
     database "dlopen /usr/local/samba/lib/bind9/dlz_bind9_11.so";=0A=
=0A=
    # For BIND 9.12.x=0A=
    # database "dlopen /usr/local/samba/lib/bind9/dlz_bind9_12.so";=0A=
};=0A=
=0A=
Setting up BIND9 options and keytab for Kerberos=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
=0A=
# nano /etc/named.conf=0A=
=0A=
Add the following to the options {} section of your main BIND named.conf fi=
le. For example:=0A=
=0A=
options {=0A=
     [...]=0A=
     tkey-gssapi-keytab "/usr/local/samba/private/dns.keytab";=0A=
     minimal-responses yes;=0A=
};=0A=
=0A=
Verify that your /etc/krb5.conf Kerberos client configuration file is reada=
ble by your BIND user. For example:=0A=
=0A=
# ls -l /etc/krb5.conf=0A=
=0A=
Output:=0A=
=0A=
-rw-r--r--. 1 root root 97 Feb 15 00:49 /etc/krb5.conf=0A=
=0A=
# chown root:named /etc/krb5.conf=0A=
=0A=
Verify that the nsupdate utility exists on your domain controller (DC):=0A=
=0A=
# which nsupdate=0A=
=0A=
/usr/bin/nsupdate=0A=
=0A=
Starting the BIND DNS Service=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=0A=
=0A=
# named-checkconf=0A=
=0A=
# systemctl enable named.service=0A=
=0A=
# systemctl start named.service=0A=
=0A=
# systemctl status named.service=0A=
 =0A=
Output:=0A=
=0A=
=1B$B!|=1B(B named.service - Berkeley Internet Name Domain (DNS)=0A=
   Loaded: loaded (/usr/lib/systemd/system/named.service; enabled; vendor p=
reset: disabled)=0A=
   Active: active (running) since Sat 2020-02-15 09:28:54 +08; 26s ago=0A=
  Process: 3670 ExecStart=3D/usr/sbin/named -u named -c ${NAMEDCONF} $OPTIO=
NS (code=3Dexited, status=3D0/SUCCESS)=0A=
  Process: 3667 ExecStartPre=3D/bin/bash -c if [ ! "$DISABLE_ZONE_CHECKING"=
 =3D=3D "yes" ]; then /usr/sbin/named-checkconf -z "$NAMEDCONF"; else echo =
"Checking of zone files is disab>=0A=
 Main PID: 3673 (named)=0A=
    Tasks: 4 (limit: 23972)=0A=
   Memory: 73.1M=0A=
   CGroup: /system.slice/named.service=0A=
           =1B$B(&(!=1B(B3673 /usr/sbin/named -u named -c /etc/named.conf=
=0A=
=0A=
Feb 15 09:28:54 dc1 named[3673]: zone 0.in-addr.arpa/IN: loaded serial 0=0A=
Feb 15 09:28:54 dc1 named[3673]: zone localhost/IN: loaded serial 0=0A=
Feb 15 09:28:54 dc1 named[3673]: zone 1.0.0.127.in-addr.arpa/IN: loaded ser=
ial 0=0A=
Feb 15 09:28:54 dc1 named[3673]: zone localhost.localdomain/IN: loaded seri=
al 0=0A=
Feb 15 09:28:54 dc1 named[3673]: zone 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0=
.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa/IN: loaded serial 0=0A=
Feb 15 09:28:54 dc1 named[3673]: all zones loaded=0A=
Feb 15 09:28:54 dc1 named[3673]: running=0A=
Feb 15 09:28:54 dc1 systemd[1]: Started Berkeley Internet Name Domain (DNS)=
.=0A=
Feb 15 09:29:04 dc1 named[3673]: managed-keys-zone: Unable to fetch DNSKEY =
set '.': timed out=0A=
Feb 15 09:29:04 dc1 named[3673]: resolver priming query complete=0A=
=0A=
I still cannot find the mandatory DNS records. Re-provisioning Samba AD DC =
again.=0A=
=0A=
# cd /usr/local/samba/etc=0A=
=0A=
# mv smb.conf smb.conf.bak=0A=
=0A=
# samba-tool domain provision --use-rfc2307 --interactive=0A=
=0A=
Realm [TEO-EN-MING.CORP]:  =0A=
Domain [TEO-EN-MING]:  =0A=
Server Role (dc, member, standalone) [dc]:  =0A=
DNS backend (SAMBA_INTERNAL, BIND9_FLATFILE, BIND9_DLZ, NONE) [SAMBA_INTERN=
AL]:  BIND9_DLZ=0A=
Administrator password: =0A=
Retype password: =0A=
INFO 2020-02-15 09:34:24,411 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2128: Looking up IPv4 addresses=0A=
WARNING 2020-02-15 09:34:24,411 pid:3873 /usr/local/samba/lib64/python3.6/s=
ite-packages/samba/provision/__init__.py #2134: More than one IPv4 address =
found. Using 192.168.1.10=0A=
INFO 2020-02-15 09:34:24,411 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2145: Looking up IPv6 addresses=0A=
WARNING 2020-02-15 09:34:24,412 pid:3873 /usr/local/samba/lib64/python3.6/s=
ite-packages/samba/provision/__init__.py #2150: More than one IPv6 address =
found. Using 2401:7400:c802:de67::14c2=0A=
INFO 2020-02-15 09:34:24,817 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2323: Setting up secrets.ldb=0A=
INFO 2020-02-15 09:34:25,101 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2329: Setting up the registry=0A=
INFO 2020-02-15 09:34:25,269 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2332: Setting up the privileges data=
base=0A=
INFO 2020-02-15 09:34:25,783 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2335: Setting up idmap db=0A=
INFO 2020-02-15 09:34:26,233 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2342: Setting up SAM db=0A=
INFO 2020-02-15 09:34:26,316 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #898: Setting up sam.ldb partitions a=
nd settings=0A=
INFO 2020-02-15 09:34:26,317 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #910: Setting up sam.ldb rootDSE=0A=
INFO 2020-02-15 09:34:26,367 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1339: Pre-loading the Samba 4 and AD=
 schema=0A=
Unable to determine the DomainSID, can not enforce uniqueness constraint on=
 local domainSIDs=0A=
=0A=
INFO 2020-02-15 09:34:26,551 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1417: Adding DomainDN: DC=3Dteo-en-m=
ing,DC=3Dcorp=0A=
INFO 2020-02-15 09:34:26,684 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1449: Adding configuration container=
=0A=
INFO 2020-02-15 09:34:26,791 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1464: Setting up sam.ldb schema=0A=
INFO 2020-02-15 09:34:30,087 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1482: Setting up sam.ldb configurati=
on data=0A=
INFO 2020-02-15 09:34:30,230 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1523: Setting up display specifiers=
=0A=
INFO 2020-02-15 09:34:32,425 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1531: Modifying display specifiers a=
nd extended rights=0A=
INFO 2020-02-15 09:34:32,465 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1538: Adding users container=0A=
INFO 2020-02-15 09:34:32,467 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1544: Modifying users container=0A=
INFO 2020-02-15 09:34:32,467 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1547: Adding computers container=0A=
INFO 2020-02-15 09:34:32,469 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1553: Modifying computers container=
=0A=
INFO 2020-02-15 09:34:32,470 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1557: Setting up sam.ldb data=0A=
INFO 2020-02-15 09:34:32,608 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1587: Setting up well known security=
 principals=0A=
INFO 2020-02-15 09:34:32,667 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1601: Setting up sam.ldb users and g=
roups=0A=
INFO 2020-02-15 09:34:32,967 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #1609: Setting up self join=0A=
Repacking database from v1 to v2 format (first record CN=3DuserPKCS12,CN=3D=
Schema,CN=3DConfiguration,DC=3Dteo-en-ming,DC=3Dcorp)=0A=
Repack: re-packed 10000 records so far=0A=
Repacking database from v1 to v2 format (first record CN=3DpKICertificateTe=
mplate-Display,CN=3D406,CN=3DDisplaySpecifiers,CN=3DConfiguration,DC=3Dteo-=
en-ming,DC=3Dcorp)=0A=
Repacking database from v1 to v2 format (first record CN=3D4dfbb973-8a62-43=
10-a90c-776e00f83222,CN=3DOperations,CN=3DDomainUpdates,CN=3DSystem,DC=3Dte=
o-en-ming,DC=3Dcorp)=0A=
INFO 2020-02-15 09:34:35,720 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/sambadns.py #1138: Adding DNS accounts=0A=
INFO 2020-02-15 09:34:35,963 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/sambadns.py #1172: Creating CN=3DMicrosoftDNS,CN=
=3DSystem,DC=3Dteo-en-ming,DC=3Dcorp=0A=
INFO 2020-02-15 09:34:35,982 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/sambadns.py #1185: Creating DomainDnsZones and Fo=
restDnsZones partitions=0A=
INFO 2020-02-15 09:34:36,248 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/sambadns.py #1190: Populating DomainDnsZones and =
ForestDnsZones partitions=0A=
Repacking database from v1 to v2 format (first record DC=3Dl.root-servers.n=
et,DC=3DRootDNSServers,CN=3DMicrosoftDNS,DC=3DDomainDnsZones,DC=3Dteo-en-mi=
ng,DC=3Dcorp)=0A=
Repacking database from v1 to v2 format (first record CN=3DMicrosoftDNS,DC=
=3DForestDnsZones,DC=3Dteo-en-ming,DC=3Dcorp)=0A=
INFO 2020-02-15 09:34:37,633 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/sambadns.py #1272: See /usr/local/samba/bind-dns/=
named.conf for an example configuration include file for BIND=0A=
INFO 2020-02-15 09:34:37,633 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/sambadns.py #1274: and /usr/local/samba/bind-dns/=
named.txt for further documentation required for secure DNS updates=0A=
INFO 2020-02-15 09:34:37,763 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2032: Setting up sam.ldb rootDSE mar=
king as synchronized=0A=
INFO 2020-02-15 09:34:37,804 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2037: Fixing provision GUIDs=0A=
INFO 2020-02-15 09:34:38,781 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2395: A Kerberos configuration suita=
ble for Samba AD has been generated at /usr/local/samba/private/krb5.conf=
=0A=
INFO 2020-02-15 09:34:38,781 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2396: Merge the contents of this fil=
e with your system krb5.conf or replace it with this one. Do not create a s=
ymlink!=0A=
INFO 2020-02-15 09:34:39,223 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #2102: Setting up fake yp server sett=
ings=0A=
INFO 2020-02-15 09:34:39,438 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #491: Once the above files are instal=
led, your Samba AD server will be ready to use=0A=
INFO 2020-02-15 09:34:39,439 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #495: Server Role:           active d=
irectory domain controller=0A=
INFO 2020-02-15 09:34:39,439 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #496: Hostname:              dc1=0A=
INFO 2020-02-15 09:34:39,439 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #497: NetBIOS Domain:        TEO-EN-M=
ING=0A=
INFO 2020-02-15 09:34:39,439 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #498: DNS Domain:            teo-en-m=
ing.corp=0A=
INFO 2020-02-15 09:34:39,439 pid:3873 /usr/local/samba/lib64/python3.6/site=
-packages/samba/provision/__init__.py #499: DOMAIN SID:            S-1-5-21=
-2121330042-1058780221-1881093528=0A=
=0A=
# cat /usr/local/samba/etc/smb.conf=0A=
=0A=
# Global parameters=0A=
[global]=0A=
	netbios name =3D DC1=0A=
	realm =3D TEO-EN-MING.CORP=0A=
	server role =3D active directory domain controller=0A=
	server services =3D s3fs, rpc, nbt, wrepl, ldap, cldap, kdc, drepl, winbin=
dd, ntp_signd, kcc, dnsupdate=0A=
	workgroup =3D TEO-EN-MING=0A=
	idmap_ldb:use rfc2307 =3D yes=0A=
=0A=
[sysvol]=0A=
	path =3D /usr/local/samba/var/locks/sysvol=0A=
	read only =3D No=0A=
=0A=
[netlogon]=0A=
	path =3D /usr/local/samba/var/locks/sysvol/teo-en-ming.corp/scripts=0A=
	read only =3D No=0A=
=0A=
=0A=
# systemctl start samba-ad-dc=0A=
=0A=
TROUBLESHOOTING SAMBA INSTALLATION BY RE-COMPILING SAMBA FROM SOURCE AGAIN=
=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
I was afraid that SELINUX might affect the previous build of Samba from sou=
rce.=0A=
=0A=
=0A=
# cd /root=0A=
=0A=
# rm -rf samba-4.11.6=0A=
=0A=
# systemctl stop samba-ad-dc=0A=
=0A=
# cd /usr/local=0A=
=0A=
# rm -rf samba/=0A=
=0A=
# cd /root=0A=
=0A=
# tar xfvz samba-4.11.6.tar.gz=0A=
=0A=
# cd samba-4.11.6/=0A=
=0A=
# ./configure=0A=
=0A=
# make -j 4=0A=
=0A=
Output:=0A=
=0A=
Waf: Leaving directory `/root/samba-4.11.6/bin/default'=0A=
'build' finished successfully (9m21.630s)=0A=
=0A=
# make install=0A=
=0A=
Output:=0A=
=0A=
Waf: Leaving directory `/root/samba-4.11.6/bin/default'=0A=
'install' finished successfully (2m47.846s)=0A=
=0A=
Provisioning Samba AD DC from scratch after rebuilding Samba from source.=
=0A=
=0A=
# samba-tool domain provision --use-rfc2307 --interactive=0A=
=0A=
Realm [TEO-EN-MING.CORP]:  =0A=
Domain [TEO-EN-MING]:  =0A=
Server Role (dc, member, standalone) [dc]:  =0A=
DNS backend (SAMBA_INTERNAL, BIND9_FLATFILE, BIND9_DLZ, NONE) [SAMBA_INTERN=
AL]:  BIND9_DLZ=0A=
Administrator password: =0A=
Retype password: =0A=
INFO 2020-02-15 10:00:20,082 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #2128: Looking up IPv4 addresses=0A=
WARNING 2020-02-15 10:00:20,083 pid:28453 /usr/local/samba/lib64/python3.6/=
site-packages/samba/provision/__init__.py #2134: More than one IPv4 address=
 found. Using 192.168.1.10=0A=
INFO 2020-02-15 10:00:20,083 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #2145: Looking up IPv6 addresses=0A=
WARNING 2020-02-15 10:00:20,083 pid:28453 /usr/local/samba/lib64/python3.6/=
site-packages/samba/provision/__init__.py #2150: More than one IPv6 address=
 found. Using 2401:7400:c802:de67::14c2=0A=
INFO 2020-02-15 10:00:20,505 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #2319: Setting up share.ldb=0A=
INFO 2020-02-15 10:00:20,871 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #2323: Setting up secrets.ldb=0A=
INFO 2020-02-15 10:00:21,131 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #2329: Setting up the registry=0A=
INFO 2020-02-15 10:00:22,314 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #2332: Setting up the privileges dat=
abase=0A=
INFO 2020-02-15 10:00:22,838 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #2335: Setting up idmap db=0A=
INFO 2020-02-15 10:00:23,230 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #2342: Setting up SAM db=0A=
INFO 2020-02-15 10:00:23,322 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #898: Setting up sam.ldb partitions =
and settings=0A=
INFO 2020-02-15 10:00:23,324 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #910: Setting up sam.ldb rootDSE=0A=
INFO 2020-02-15 10:00:23,398 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #1339: Pre-loading the Samba 4 and A=
D schema=0A=
Unable to determine the DomainSID, can not enforce uniqueness constraint on=
 local domainSIDs=0A=
=0A=
INFO 2020-02-15 10:00:23,573 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #1417: Adding DomainDN: DC=3Dteo-en-=
ming,DC=3Dcorp=0A=
INFO 2020-02-15 10:00:23,653 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #1449: Adding configuration containe=
r=0A=
INFO 2020-02-15 10:00:23,749 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #1464: Setting up sam.ldb schema=0A=
INFO 2020-02-15 10:00:27,115 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #1482: Setting up sam.ldb configurat=
ion data=0A=
INFO 2020-02-15 10:00:27,261 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #1523: Setting up display specifiers=
=0A=
INFO 2020-02-15 10:00:29,491 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #1531: Modifying display specifiers =
and extended rights=0A=
INFO 2020-02-15 10:00:29,531 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #1538: Adding users container=0A=
INFO 2020-02-15 10:00:29,532 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #1544: Modifying users container=0A=
INFO 2020-02-15 10:00:29,533 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #1547: Adding computers container=0A=
INFO 2020-02-15 10:00:29,534 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #1553: Modifying computers container=
=0A=
INFO 2020-02-15 10:00:29,535 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #1557: Setting up sam.ldb data=0A=
INFO 2020-02-15 10:00:29,674 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #1587: Setting up well known securit=
y principals=0A=
INFO 2020-02-15 10:00:29,735 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #1601: Setting up sam.ldb users and =
groups=0A=
INFO 2020-02-15 10:00:30,058 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #1609: Setting up self join=0A=
Repacking database from v1 to v2 format (first record CN=3Drpc-Ns-Bindings,=
CN=3DSchema,CN=3DConfiguration,DC=3Dteo-en-ming,DC=3Dcorp)=0A=
Repack: re-packed 10000 records so far=0A=
Repacking database from v1 to v2 format (first record CN=3DnTFRSSubscriber-=
Display,CN=3D40C,CN=3DDisplaySpecifiers,CN=3DConfiguration,DC=3Dteo-en-ming=
,DC=3Dcorp)=0A=
Repacking database from v1 to v2 format (first record CN=3DIncoming Forest =
Trust Builders,CN=3DBuiltin,DC=3Dteo-en-ming,DC=3Dcorp)=0A=
INFO 2020-02-15 10:00:33,052 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/sambadns.py #1138: Adding DNS accounts=0A=
INFO 2020-02-15 10:00:33,285 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/sambadns.py #1172: Creating CN=3DMicrosoftDNS,CN=
=3DSystem,DC=3Dteo-en-ming,DC=3Dcorp=0A=
INFO 2020-02-15 10:00:33,305 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/sambadns.py #1185: Creating DomainDnsZones and F=
orestDnsZones partitions=0A=
INFO 2020-02-15 10:00:33,511 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/sambadns.py #1190: Populating DomainDnsZones and=
 ForestDnsZones partitions=0A=
Repacking database from v1 to v2 format (first record DC=3D@,DC=3Dteo-en-mi=
ng.corp,CN=3DMicrosoftDNS,DC=3DDomainDnsZones,DC=3Dteo-en-ming,DC=3Dcorp)=
=0A=
Repacking database from v1 to v2 format (first record DC=3D_ldap._tcp.Defau=
lt-First-Site-Name._sites.gc,DC=3D_msdcs.teo-en-ming.corp,CN=3DMicrosoftDNS=
,DC=3DForestDnsZones,DC=3Dteo-en-ming,DC=3Dcorp)=0A=
INFO 2020-02-15 10:00:34,921 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/sambadns.py #1272: See /usr/local/samba/bind-dns=
/named.conf for an example configuration include file for BIND=0A=
INFO 2020-02-15 10:00:34,921 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/sambadns.py #1274: and /usr/local/samba/bind-dns=
/named.txt for further documentation required for secure DNS updates=0A=
INFO 2020-02-15 10:00:35,045 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #2032: Setting up sam.ldb rootDSE ma=
rking as synchronized=0A=
INFO 2020-02-15 10:00:35,095 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #2037: Fixing provision GUIDs=0A=
INFO 2020-02-15 10:00:36,238 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #2395: A Kerberos configuration suit=
able for Samba AD has been generated at /usr/local/samba/private/krb5.conf=
=0A=
INFO 2020-02-15 10:00:36,238 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #2396: Merge the contents of this fi=
le with your system krb5.conf or replace it with this one. Do not create a =
symlink!=0A=
INFO 2020-02-15 10:00:36,771 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #2102: Setting up fake yp server set=
tings=0A=
INFO 2020-02-15 10:00:37,012 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #491: Once the above files are insta=
lled, your Samba AD server will be ready to use=0A=
INFO 2020-02-15 10:00:37,013 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #495: Server Role:           active =
directory domain controller=0A=
INFO 2020-02-15 10:00:37,013 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #496: Hostname:              dc1=0A=
INFO 2020-02-15 10:00:37,013 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #497: NetBIOS Domain:        TEO-EN-=
MING=0A=
INFO 2020-02-15 10:00:37,013 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #498: DNS Domain:            teo-en-=
ming.corp=0A=
INFO 2020-02-15 10:00:37,013 pid:28453 /usr/local/samba/lib64/python3.6/sit=
e-packages/samba/provision/__init__.py #499: DOMAIN SID:            S-1-5-2=
1-4032533190-753116703-2394070240=0A=
=0A=
# systemctl start samba-ad-dc=0A=
=0A=
TROUBLESHOOTING THE BIND9_DLZ BACKEND=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
# samba_upgradedns --dns-backend=3DBIND9_DLZ=0A=
=0A=
Output:=0A=
=0A=
Reading domain information=0A=
DNS accounts already exist=0A=
No zone file /usr/local/samba/bind-dns/dns/TEO-EN-MING.CORP.zone=0A=
DNS records will be automatically created=0A=
DNS partitions already exist=0A=
dns-dc1 account already exists=0A=
See /usr/local/samba/bind-dns/named.conf for an example configuration inclu=
de file for BIND=0A=
and /usr/local/samba/bind-dns/named.txt for further documentation required =
for secure DNS updates=0A=
Finished upgrading DNS=0A=
=0A=
TROUBLESHOOTING "MISSING" MANDATORY SAMBA DNS RECORDS=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=0A=
=0A=
REFERENCE=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
Finally! I found the problem and discovered the solution.=0A=
=0A=
Guide: CentOS 7 NetworkManager Keeps Overwriting /etc/resolv.conf=0A=
=0A=
Link: https://ma.ttias.be/centos-7-networkmanager-keeps-overwriting-etcreso=
lv-conf/=0A=
=0A=
To prevent Network Manager to overwrite your resolv.conf changes, remove th=
e DNS1, DNS2, =1B$B!D=1B(B lines from /etc/sysconfig/network-scripts/ifcfg-=
*.=0A=
=0A=
# cd /etc/sysconfig/network-scripts/=0A=
=0A=
# nano ifcfg-ens3=0A=
=0A=
Remove DNS1 entry.=0A=
=0A=
To make BIND listen on all interfaces=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
# nano /etc/named.conf=0A=
=0A=
Change the following entry:=0A=
=0A=
listen-on port 53 { any; };=0A=
=0A=
# systemctl restart named=0A=
=0A=
# netstat -anp | grep -v unix | grep LISTEN=0A=
=0A=
tcp        0      0 0.0.0.0:111             0.0.0.0:*               LISTEN =
     1/systemd           =0A=
tcp        0      0 0.0.0.0:464             0.0.0.0:*               LISTEN =
     28855/samba         =0A=
tcp        0      0 192.168.122.1:53        0.0.0.0:*               LISTEN =
     29436/named         =0A=
tcp        0      0 192.168.1.10:53         0.0.0.0:*               LISTEN =
     29436/named         =0A=
tcp        0      0 127.0.0.1:53            0.0.0.0:*               LISTEN =
     29436/named         =0A=
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN =
     1090/sshd           =0A=
tcp        0      0 127.0.0.1:631           0.0.0.0:*               LISTEN =
     1087/cupsd          =0A=
tcp        0      0 0.0.0.0:88              0.0.0.0:*               LISTEN =
     28855/samba         =0A=
tcp        0      0 127.0.0.1:953           0.0.0.0:*               LISTEN =
     29436/named         =0A=
tcp        0      0 0.0.0.0:636             0.0.0.0:*               LISTEN =
     28847/samba         =0A=
tcp        0      0 0.0.0.0:445             0.0.0.0:*               LISTEN =
     28839/smbd          =0A=
tcp        0      0 0.0.0.0:49152           0.0.0.0:*               LISTEN =
     28837/samba         =0A=
tcp        0      0 0.0.0.0:49153           0.0.0.0:*               LISTEN =
     28845/samba         =0A=
tcp        0      0 0.0.0.0:49154           0.0.0.0:*               LISTEN =
     28845/samba         =0A=
tcp        0      0 0.0.0.0:3268            0.0.0.0:*               LISTEN =
     28847/samba         =0A=
tcp        0      0 0.0.0.0:3269            0.0.0.0:*               LISTEN =
     28847/samba         =0A=
tcp        0      0 0.0.0.0:389             0.0.0.0:*               LISTEN =
     28847/samba         =0A=
tcp        0      0 0.0.0.0:135             0.0.0.0:*               LISTEN =
     28845/samba         =0A=
tcp        0      0 0.0.0.0:139             0.0.0.0:*               LISTEN =
     28839/smbd          =0A=
tcp        0      0 0.0.0.0:5355            0.0.0.0:*               LISTEN =
     1597/systemd-resolv =0A=
tcp6       0      0 :::111                  :::*                    LISTEN =
     1/systemd           =0A=
tcp6       0      0 :::464                  :::*                    LISTEN =
     28855/samba         =0A=
tcp6       0      0 ::1:53                  :::*                    LISTEN =
     29436/named         =0A=
tcp6       0      0 :::22                   :::*                    LISTEN =
     1090/sshd           =0A=
tcp6       0      0 ::1:631                 :::*                    LISTEN =
     1087/cupsd          =0A=
tcp6       0      0 :::88                   :::*                    LISTEN =
     28855/samba         =0A=
tcp6       0      0 ::1:953                 :::*                    LISTEN =
     29436/named         =0A=
tcp6       0      0 :::636                  :::*                    LISTEN =
     28847/samba         =0A=
tcp6       0      0 :::445                  :::*                    LISTEN =
     28839/smbd          =0A=
tcp6       0      0 :::49152                :::*                    LISTEN =
     28837/samba         =0A=
tcp6       0      0 :::49153                :::*                    LISTEN =
     28845/samba         =0A=
tcp6       0      0 :::49154                :::*                    LISTEN =
     28845/samba         =0A=
tcp6       0      0 :::3268                 :::*                    LISTEN =
     28847/samba         =0A=
tcp6       0      0 :::3269                 :::*                    LISTEN =
     28847/samba         =0A=
tcp6       0      0 :::389                  :::*                    LISTEN =
     28847/samba         =0A=
tcp6       0      0 :::135                  :::*                    LISTEN =
     28845/samba         =0A=
tcp6       0      0 :::5355                 :::*                    LISTEN =
     1597/systemd-resolv =0A=
tcp6       0      0 :::139                  :::*                    LISTEN =
     28839/smbd          =0A=
=0A=
Modify /etc/resolv.conf again. This is the crux of the problem.=0A=
=0A=
# nano /etc/resolv.conf=0A=
=0A=
search teo-en-ming.corp=0A=
nameserver 192.168.1.10=0A=
=0A=
Verifying DNS (Successful this time)=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
$ host -t SRV _ldap._tcp.teo-en-ming.corp.=0A=
=0A=
Output:=0A=
=0A=
_ldap._tcp.teo-en-ming.corp has SRV record 0 100 389 dc1.teo-en-ming.corp.=
=0A=
=0A=
$ host -t SRV _kerberos._udp.teo-en-ming.corp.=0A=
=0A=
Output:=0A=
=0A=
_kerberos._udp.teo-en-ming.corp has SRV record 0 100 88 dc1.teo-en-ming.cor=
p.=0A=
=0A=
$ host -t A dc1.teo-en-ming.corp.=0A=
=0A=
Output:=0A=
=0A=
dc1.teo-en-ming.corp has address 192.168.122.1=0A=
dc1.teo-en-ming.corp has address 192.168.1.10=0A=
=0A=
Verifying Kerberos (Successful this time)=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
# kninit administrator=0A=
=0A=
Output: =0A=
=0A=
Password for administrator@TEO-EN-MING.CORP: =0A=
Warning: Your password will expire in 41 days on Sat 28 Mar 2020 10:00:30 A=
M +08=0A=
=0A=
# klist=0A=
=0A=
Output:=0A=
=0A=
Ticket cache: FILE:/tmp/krb5cc_0=0A=
Default principal: administrator@TEO-EN-MING.CORP=0A=
=0A=
Valid starting       Expires              Service principal=0A=
02/15/2020 10:56:56  02/15/2020 20:56:56  krbtgt/TEO-EN-MING.CORP@TEO-EN-MI=
NG.CORP=0A=
	renew until 02/16/2020 10:56:53=0A=
=0A=
OVERWHELMING SUCCESS!=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
Joining Domain from Windows 10 Pro QEMU/KVM virtual machine=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
Install Windows 10 Pro version 1909 as a QEMU/KVM virtual machine.=0A=
=0A=
Ping Samba AD DC from Windows.=0A=
=0A=
ping 192.168.1.10=0A=
=0A=
SUCCESS!=0A=
=0A=
Configure Preferred DNS Server as 192.168.1.10 for your virtual NIC.=0A=
=0A=
Alternate DNS Server: 8.8.8.8 (Compulsory for internet access)=0A=
=0A=
REFERENCE GUIDE=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
Guide: DNS Administration=0A=
=0A=
Link: https://wiki.samba.org/index.php/DNS_Administration=0A=
=0A=
Listing zone records=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
# samba-tool dns query 192.168.1.10 teo-en-ming.corp @ ALL -U administrator=
=0A=
=0A=
Output:=0A=
=0A=
Password for [TEO-EN-MING\administrator]:=0A=
  Name=3D, Records=3D6, Children=3D0=0A=
    SOA: serial=3D241, refresh=3D900, retry=3D600, expire=3D86400, minttl=
=3D3600, ns=3Ddc1.teo-en-ming.corp., email=3Dhostmaster.teo-en-ming.corp. (=
flags=3D600000f0, serial=3D241, ttl=3D3600)=0A=
    NS: dc1.teo-en-ming.corp. (flags=3D600000f0, serial=3D1, ttl=3D900)=0A=
    A: 192.168.1.10 (flags=3D600000f0, serial=3D1, ttl=3D900)=0A=
    AAAA: 2401:7400:c802:de67:0000:0000:0000:14c2 (flags=3D600000f0, serial=
=3D1, ttl=3D900)=0A=
    A: 192.168.122.1 (flags=3D600000f0, serial=3D26, ttl=3D900)=0A=
    AAAA: 2401:7400:c802:de67:0d19:690d:f659:ad40 (flags=3D600000f0, serial=
=3D27, ttl=3D900)=0A=
  Name=3D_msdcs, Records=3D0, Children=3D0=0A=
  Name=3D_sites, Records=3D0, Children=3D1=0A=
  Name=3D_tcp, Records=3D0, Children=3D4=0A=
  Name=3D_udp, Records=3D0, Children=3D2=0A=
  Name=3Ddc1, Records=3D4, Children=3D0=0A=
    A: 192.168.1.10 (flags=3Df0, serial=3D1, ttl=3D900)=0A=
    AAAA: 2401:7400:c802:de67:0000:0000:0000:14c2 (flags=3Df0, serial=3D1, =
ttl=3D900)=0A=
    A: 192.168.122.1 (flags=3Df0, serial=3D24, ttl=3D900)=0A=
    AAAA: 2401:7400:c802:de67:0d19:690d:f659:ad40 (flags=3Df0, serial=3D25,=
 ttl=3D900)=0A=
  Name=3DDomainDnsZones, Records=3D0, Children=3D2=0A=
  Name=3DForestDnsZones, Records=3D0, Children=3D2=0A=
=0A=
Disable IPv6 on Windows 10 Pro QEMU/KVM virtual machine.=0A=
=0A=
Deleting Unneccessary DNS Records (OPTIONAL TASK)=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
# samba-tool dns delete 192.168.1.10 teo-en-ming.corp teo-en-ming.corp A 19=
2.168.122.1 -U administrator=0A=
=0A=
# samba-tool dns delete 192.168.1.10 teo-en-ming.corp teo-en-ming.corp AAAA=
 2401:7400:c802:de67:0000:0000:0000:14c2 -U administrator=0A=
=0A=
# samba-tool dns delete 192.168.1.10 teo-en-ming.corp teo-en-ming.corp AAAA=
 2401:7400:c802:de67:0d19:690d:f659:ad40 -U administrator=0A=
=0A=
# samba-tool dns delete 192.168.1.10 teo-en-ming.corp dc1 A 192.168.122.1 -=
U administrator=0A=
=0A=
# samba-tool dns delete 192.168.1.10 teo-en-ming.corp dc1 AAAA 2401:7400:c8=
02:de67:0000:0000:0000:14c2 -U administrator=0A=
=0A=
# samba-tool dns delete 192.168.1.10 teo-en-ming.corp dc1 AAAA 2401:7400:c8=
02:de67:0d19:690d:f659:ad40 -U administrator=0A=
=0A=
Disabling the Firewall on CentOS 8.1=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =0A=
=0A=
# systemctl stop firewalld=0A=
=0A=
# systemctl disable firewalld=0A=
=0A=
Join Domain from Windows 10 Pro QEMU/KVM Virtual Machine=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=0A=
=0A=
Domain: teo-en-ming.corp=0A=
=0A=
Welcome to the teo-en-ming.corp domain.=0A=
=0A=
Download and install Microsoft Remote Server Administration Tools (RSAT) fo=
r Windows 10.=0A=
=0A=
Restart Windows 10 Pro QEMU/KVM virtual machine.=0A=
=0A=
Login as domain administrator.=0A=
=0A=
User: TEO-EN-MING\administrator=0A=
=0A=
Password: Unknown=0A=
=0A=
Open Active Directory Users and Computers.=0A=
=0A=
Final Success!=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
=0A=
AUTHOR: MR. TURRITOPSIS DOHRNII TEO EN MING, SINGAPORE=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
-----BEGIN EMAIL SIGNATURE-----=0A=
=0A=
The Gospel for all Targeted Individuals (TIs):=0A=
=0A=
[The New York Times] Microwave Weapons Are Prime Suspect in Ills of=0A=
U.S. Embassy Workers=0A=
=0A=
Link: https://www.nytimes.com/2018/09/01/science/sonic-attack-cuba-microwav=
e.html=0A=
=0A=
***************************************************************************=
*****************=0A=
=0A=
=0A=
=0A=
Singaporean Mr. Turritopsis Dohrnii Teo En Ming's Academic=0A=
Qualifications as at 14 Feb 2019 and refugee seeking attempts at the United=
 Nations Refugee Agency Bangkok (21 Mar 2017), in Taiwan (5 Aug 2019) and A=
ustralia (25 Dec 2019 to 9 Jan 2020):=0A=
=0A=
=0A=
[1] https://tdtemcerts.wordpress.com/=0A=
=0A=
[2] https://tdtemcerts.blogspot.sg/=0A=
=0A=
[3] https://www.scribd.com/user/270125049/Teo-En-Ming=0A=
=0A=
-----END EMAIL SIGNATURE-----=0A=
=0A=
=0A=
=0A=
