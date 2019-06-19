Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7104B6C6
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 13:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731495AbfFSLLV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 07:11:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46012 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727242AbfFSLLV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 07:11:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5JB9FdF161262;
        Wed, 19 Jun 2019 11:11:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=2E/xxyfxilbbJIBxuSFlUUT7YrP/B/T+4iRiiUse0uo=;
 b=Dz/lb8ThJSFobMJU0TB4MmL622Uy0SZPG63RkWrvfUCtqefpQMO+MIH7PCANsDOw+60/
 Jd/fpkdEAR48P61ssb9HAdtVriFFGB66v9gEFJAWhdHUxnxz//NL9RMerWVUtiVcO2d3
 7X4fBwW2aqEC5Bx5CbGdOdIUHoXnchWSjkrnexMhXDQK+aA2uMA9Xkrhkwtduqd8pu7j
 tsZgetqVU+2aacvtP+RyO9uOFyFr6y8NQc6qInx4BlenQoKphiWe5L8+QiMqjuTcfj+7
 XMd5wq2uAm5s3LGRrgvjnyZYtHndateU0SUJmCWGC9kWZo0pADPvYfsTSdLQvmxX9oIL Pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2t7809aqp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 11:11:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5JB997K119535;
        Wed, 19 Jun 2019 11:11:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2t77yn1cqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 11:11:03 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5JBB1iY005512;
        Wed, 19 Jun 2019 11:11:01 GMT
Received: from [192.168.14.112] (/109.64.216.174)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Jun 2019 04:11:01 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v2] KVM: x86: Modify struct kvm_nested_state to have
 explicit fields for data
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <e2800277-4d44-5caa-1122-c36487f6e6bb@redhat.com>
Date:   Wed, 19 Jun 2019 14:10:58 +0300
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C8A35660-C78F-4EBB-BCAF-8C9BCC9D323C@oracle.com>
References: <1560875046-26279-1-git-send-email-pbonzini@redhat.com>
 <D2867F96-6B8D-4A1D-9F6F-CF0F171614BC@oracle.com>
 <e2800277-4d44-5caa-1122-c36487f6e6bb@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=997
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906190094
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906190094
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 19 Jun 2019, at 13:45, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 19/06/19 00:36, Liran Alon wrote:
>>=20
>>=20
>>> On 18 Jun 2019, at 19:24, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>>=20
>>> From: Liran Alon <liran.alon@oracle.com>
>>>=20
>>> Improve the KVM_{GET,SET}_NESTED_STATE structs by detailing the =
format
>>> of VMX nested state data in a struct.
>>>=20
>>> In order to avoid changing the ioctl values of
>>> KVM_{GET,SET}_NESTED_STATE, there is a need to preserve
>>> sizeof(struct kvm_nested_state). This is done by defining the data
>>> struct as "data.vmx[0]". It was the most elegant way I found to
>>> preserve struct size while still keeping struct readable and easy to
>>> maintain. It does have a misfortunate side-effect that now it has to =
be
>>> accessed as "data.vmx[0]" rather than just "data.vmx".
>>>=20
>>> Because we are already modifying these structs, I also modified the
>>> following:
>>> * Define the "format" field values as macros.
>>> * Rename vmcs_pa to vmcs12_pa for better readability.
>>>=20
>>> Signed-off-by: Liran Alon <liran.alon@oracle.com>
>>> [Remove SVM stubs, add KVM_STATE_NESTED_VMX_VMCS12_SIZE. - Paolo]
>>=20
>> 1) Why should we remove SVM stubs? I think it makes the interface =
intention more clear.
>> Do you see any disadvantage of having them?
>=20
> In its current state I think it would not require any state apart from
> the global flags, because MSRs can be extracted independent of
> KVM_GET_NESTED_STATE; this may change as things are cleaned up, but if
> that remains the case there would be no need for SVM structs at all.

Hmm yes I see your point. Ok I agree.

>=20
>> 2) What is the advantage of defining a separate =
KVM_STATE_NESTED_VMX_VMCS12_SIZE
>> rather than just moving VMCS12_SIZE to userspace header?
>=20
> It's just for namespace cleanliness.  I'm keeping VMCS12_SIZE for the
> arch/x86/kvm/vmx/ code because it's shorter and we're used to it, but
> userspace headers should use a more specific name.

Ok then.
I will submit my next version of QEMU patches according to this version =
of the headers.

Reviewed-by: Liran Alon <liran.alon@oracle.com>

>=20
> Paolo

