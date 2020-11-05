Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA412A7B83
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 11:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgKEKUo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 05:20:44 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52002 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbgKEKUn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 05:20:43 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A5A9Fws119053;
        Thu, 5 Nov 2020 10:20:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 in-reply-to : references : sender : from : date : message-id :
 mime-version : content-type : content-transfer-encoding;
 s=corp-2020-01-29; bh=aqKs7bL6crrEU/SvkXnc2GkG3VBgTtKGbGCoiTNEG64=;
 b=CKHoGz4sATL0jvvfHxEuzo8SBAOEJgkXQgIq2yH96QZrzi9viCw9BtYf0V2QBHqU2tES
 1gt2esrr9FR9MpfM33OKk+d9fsd9RNjVxabLKRRJr81S1qGFPbkrUBgp2YAzgFhiOxxY
 /uh2DohXnyubCDMIGCllTC8OLztSz0tqjvk7s7LMwNBGsBL+8s0YDY3F2/JfCOhd6IYK
 jGs1v6nS+pYq0EiNobNhkW2sHf4+0iWcTom87HZxOANQM1Fy5WQpsoO7yQKQKtrJW8N+
 4BbDe/RqHTCWgqnu+BGCZxCNzbeeEdrnC/SyDwJI169DOzdDJFomS8JIrtgCSRHCJUD7 /g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34hhw2u5dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 05 Nov 2020 10:20:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A5A4sHA011236;
        Thu, 5 Nov 2020 10:20:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34jf4bxn3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Nov 2020 10:20:40 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A5AKeMa021055;
        Thu, 5 Nov 2020 10:20:40 GMT
Received: from disaster-area.hh.sledj.net (/81.187.26.238)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Nov 2020 02:20:39 -0800
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 82890ae1;
        Thu, 5 Nov 2020 10:20:37 +0000 (UTC)
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     KVM <kvm@vger.kernel.org>, Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [kvm-unit-tests PATCH] x86: check that clflushopt of an MMIO address succeeds
In-Reply-To: <D92A2CAA-584C-48FE-A071-682DB287432A@gmail.com>
References: <20201103160855.261881-1-david.edmondson@oracle.com> <D92A2CAA-584C-48FE-A071-682DB287432A@gmail.com>
X-HGTTG: vroomfondel
Sender: david.edmondson@oracle.com
From:   David Edmondson <david.edmondson@oracle.com>
Date:   Thu, 05 Nov 2020 10:20:37 +0000
Message-ID: <cun1rh82jgq.fsf@vroomfondel.hh.sledj.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1 mlxscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011050071
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=1 clxscore=1011 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011050071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wednesday, 2020-11-04 at 23:53:01 -08, Nadav Amit wrote:

>> On Nov 3, 2020, at 8:08 AM, David Edmondson <david.edmondson@oracle.com>=
 wrote:
>>=20
>> Verify that the clflushopt instruction succeeds when applied to an
>> MMIO address at both cpl0 and cpl3.
>>=20
>> Suggested-by: Joao Martins <joao.m.martins@oracle.com>
>> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
>>=20
>
> [snip]
>
>> +	ret =3D pci_find_dev(PCI_VENDOR_ID_REDHAT, PCI_DEVICE_ID_REDHAT_TEST);
>> +	if (ret !=3D PCIDEVADDR_INVALID) {
>> +		pci_dev_init(&pcidev, ret);
>
> Just wondering, and perhaps this question is more general: does this test
> really need the Red-Hat test device?
>
> I know it is an emulated device, but can=E2=80=99t we use some other MMIO=
 address
> (e.g., PIT) that is also available on bare-metal?

If it's acceptable to assume that HPET is present and at 0xfed00000,
then it could be used.

dme.
--=20
Does everyone stare the way I do?
