Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF369CE23
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 13:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731021AbfHZLa1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 07:30:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57712 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727487AbfHZLa0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 07:30:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QBTG2v040257;
        Mon, 26 Aug 2019 11:30:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=Knvx/S7g9cRpvsdsj2X2PWu1o78YwISQsNgxO2lWsRM=;
 b=nfbrexnfQ93eF9K33v7QAGbLW/L/mM28fPLCKW2PWvu2RWW+5KSwEJXv5yFqlHXGYfuL
 igh75rzZYo4744dIIhBBQCCx7mzyOYIXj+d679yh3jke3Ura2i/6Sn3OV6AMtCxIxG0s
 dn1nCWVrc147f7O76NirXEqRkVF/bCMQ1P96Zb58Eb1phVD3/N+tOAe0Y9vnCb2tZIir
 jg7r1HGNfkhfjFEqilrIji/5nzqt5h3aaNoHV3l6mDNjc37gaDHdzuHa5hEQZkeyooN8
 l6tfqdOinYJ/hvhRZbEDOlP2X3S3w4s2LidiVwN8+8n5n2ZkXD3nZMW9SCPGQb4VpAp8 Yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ujw700f2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 11:30:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QBSFqN062817;
        Mon, 26 Aug 2019 11:30:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ujw6hpsnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 11:30:22 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QBUMuY002982;
        Mon, 26 Aug 2019 11:30:22 GMT
Received: from [10.30.3.14] (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 04:30:21 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [PATCH 1/2] KVM: nVMX: Always indicate HLT activity support in
 VMX_MISC MSR
From:   Nikita Leshenko <nikita.leshchenko@oracle.com>
In-Reply-To: <CALMp9eR4zO=BOZKzDowkVSR7O9Y2aqBXEvwepv6j85z4wvSyxA@mail.gmail.com>
Date:   Mon, 26 Aug 2019 14:30:18 +0300
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        Liran Alon <liran.alon@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C11C2844-CC17-436E-B304-57AD7B2C38D0@oracle.com>
References: <20190819214650.41991-1-nikita.leshchenko@oracle.com>
 <20190819214650.41991-2-nikita.leshchenko@oracle.com>
 <20190819221101.GF1916@linux.intel.com>
 <CALMp9eR4zO=BOZKzDowkVSR7O9Y2aqBXEvwepv6j85z4wvSyxA@mail.gmail.com>
To:     Jim Mattson <jmattson@google.com>
X-Mailer: Apple Mail (2.3445.9.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9360 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9360 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260129
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 21 Aug 2019, at 23:59, Jim Mattson <jmattson@google.com> wrote:
>=20
> On Mon, Aug 19, 2019 at 3:11 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
>>=20
>> On Tue, Aug 20, 2019 at 12:46:49AM +0300, Nikita Leshenko wrote:
>>> Before this commit, userspace could disable the GUEST_ACTIVITY_HLT =
bit in
>>> VMX_MISC yet KVM would happily accept GUEST_ACTIVITY_HLT activity =
state in
>>> VMCS12. We can fix it by either failing VM entries with HLT activity =
state when
>>> it's not supported or by disallowing clearing this bit.
>>>=20
>>> The latter is preferable. If we go with the former, to disable
>>> GUEST_ACTIVITY_HLT userspace also has to make CPU_BASED_HLT_EXITING =
a "must be
>>> 1" control, otherwise KVM will be presenting a bogus model to L1.
>>>=20
>>> Don't fail writes that disable GUEST_ACTIVITY_HLT to maintain =
backwards
>>> compatibility.
>>=20
>> Paolo, do we actually need to maintain backwards compatibility in =
this
>> case?  This seems like a good candidate for "fix the bug and see who =
yells".
>=20
> Google's userspace clears bit 6. Please don't fail that write!
What happens if the guest tries to use HLT activity state regardless of =
the bit?
Currently in KVM the guest will succeed, since there are no checks on VM =
entry for
that. I previously submitted a patch[1] that adds a check for that, what =
do you think
about it?

[1] https://patchwork.kernel.org/patch/11092209/

Nikita=
