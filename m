Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B14BB54D5E
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 13:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730147AbfFYLSn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 07:18:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59756 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727964AbfFYLSn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 07:18:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5PB3joD189072;
        Tue, 25 Jun 2019 11:18:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=A65qDlC65Wm3KAt7oAk2PEnLhOGxq6I1HPhmp08O82k=;
 b=W/ZSXCMBSTfX9nhxTOwmNSw5W6GUH6G5CJ8ng8SkletsRVhqJwK57/FdgRvA+oMx89Mc
 KpOjjSPh1E+EkU/ctBEGuu1IUGDKgYBJ5Okdg/F1I26G4DqwRiiONusFsZPfIiaA/IP5
 k8uQVoU3NODj77jrnZLQeQE9wFdA8EvpAIKehKP8S4b3+wtfkXswWfs2TvUAq9aYnNjQ
 /axcIxutRRLPTdF5A5MBEqdGLpjAiNH57I0UTMabFZT7eq5k9wXqyfAbPtdMuEFodbTM
 7a+5n+2KEJJvtMiDoytAcTc3BQnS/oMPKRPW6XxBStmrjY0/Zq68xutRTS/UloWMHbOw Bw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t9cyqbnu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 11:18:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5PBI7Pt112398;
        Tue, 25 Jun 2019 11:18:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2tat7c67r2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 11:18:08 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5PBI8Ik021281;
        Tue, 25 Jun 2019 11:18:08 GMT
Received: from [192.168.14.112] (/109.64.216.174)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Jun 2019 04:18:07 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] x86/kvm/nVMCS: fix VMCLEAR when Enlightened VMCS is in
 use
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <87ftnxex1g.fsf@vitty.brq.redhat.com>
Date:   Tue, 25 Jun 2019 14:18:05 +0300
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <702DE49A-0ED0-4012-B702-F4759B11B1AE@oracle.com>
References: <20190624133028.3710-1-vkuznets@redhat.com>
 <CEFF2A14-611A-417C-BC0A-8814862F26C6@oracle.com>
 <87lfxqdp3n.fsf@vitty.brq.redhat.com>
 <E7C72E0C-B44F-4CE6-8325-EA32521D75B7@oracle.com>
 <87ftnxex1g.fsf@vitty.brq.redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906250091
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906250090
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 25 Jun 2019, at 14:15, Vitaly Kuznetsov <vkuznets@redhat.com> =
wrote:
>=20
> Liran Alon <liran.alon@oracle.com> writes:
>=20
>>> On 25 Jun 2019, at 11:51, Vitaly Kuznetsov <vkuznets@redhat.com> =
wrote:
>>>=20
>>> Liran Alon <liran.alon@oracle.com> writes:
>>>=20
>>>>> On 24 Jun 2019, at 16:30, Vitaly Kuznetsov <vkuznets@redhat.com> =
wrote:
>>>>>=20
>>>>>=20
>>>>> +bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 =
*evmptr)
>>>>=20
>>>> I prefer to rename evmptr to evmcs_ptr. I think it=E2=80=99s more =
readable and sufficiently short.
>>>> In addition, I think you should return either -1ull or =
assist_page.current_nested_vmcs.
>>>> i.e. Don=E2=80=99t return evmcs_ptr by pointer but instead as a =
return-value
>>>> and get rid of the bool.
>>>=20
>>> Actually no, sorry, I'm having second thoughts here: in =
handle_vmclear()
>>> we don't care about the value of evmcs_ptr, we only want to check =
that
>>> enlightened vmentry bit is enabled in assist page. If we switch to
>>> checking evmcs_ptr against '-1', for example, we will make '-1' a =
magic
>>> value which is not in the TLFS. Windows may decide to use it for
>>> something else - and we will get a hard-to-debug bug again.
>>=20
>> I=E2=80=99m not sure I understand.
>> You are worried that when guest have setup a valid assist-page and =
set
>> enlighten_vmentry to true,
>> that assist_page.current_nested_vmcs can be -1ull and still be =
considered a valid eVMCS?
>> I don't think that's reasonable.
>=20
> No, -1ull is not a valid eVMCS - but this shouldn't change VMCLEAR
> semantics as VMCLEAR has it's own argument. It's perfectly valid to =
try
> to put a eVMCS which was previously used on a different vCPU (and thus
> which is 'active') to non-active state. The fact that we don't have an
> active eVMCS on the vCPU doing VMCLEAR shouldn't matter at all.
>=20
> --=20
> Vitaly

Oh oops sure. Yes you are right.
I forgot about the larger context here for a moment.
Sorry for the confusion. :)

-Liran

