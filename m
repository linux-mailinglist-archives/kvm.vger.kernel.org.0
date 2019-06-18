Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83BB24A595
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 17:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729528AbfFRPhw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 11:37:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54100 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729209AbfFRPhv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 11:37:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IFOVY1151641;
        Tue, 18 Jun 2019 15:36:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=AApMw5TsMqN6YhoPm41GCwqHYefC7ikF/FburAdTeBc=;
 b=JmmaQtHHEeTv8Q0MOzglhPEAuCKzTdKcD9OEfqLch2TLS0edOmkak2q3QEKb/gThXqbz
 7t10mOg1GlkPj2AosylouLRTA9qlwwPep/ubMKlqAs8mZiSTXXy1h9uvlLhujVt569mU
 eqkuFbxhWZvg92iJnFFEgxqIFQ93EsahbDdRWD0gsfjsWssCOKQzQc7Ti4sPhygj9Arg
 1PBy9+ma15TZTU0mxQimAlXvaXubWWNZ9KUH/+X3OTOnY7K5p7BVBbgWbmWL/BP79gh9
 D0a9nZI8wNrBTHNin0t+gxsNHCTwsHFHORKqKZXdQeRm+WS0tp4a5qaO14PcwTKqT1Gg kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t4r3tnbs6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 15:36:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IFZ7bu030672;
        Tue, 18 Jun 2019 15:36:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2t5h5ttcxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 15:36:57 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5IFauo6013961;
        Tue, 18 Jun 2019 15:36:56 GMT
Received: from [192.168.14.112] (/109.67.217.108)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 08:36:56 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [QEMU PATCH v3 6/9] vmstate: Add support for kernel integer types
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190618085539.GB2850@work-vm>
Date:   Tue, 18 Jun 2019 18:36:51 +0300
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, mtosatti@redhat.com,
        rth@twiddle.net, ehabkost@redhat.com, kvm@vger.kernel.org,
        jmattson@google.com, maran.wilson@oracle.com,
        Nikita Leshenko <nikita.leshchenko@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <AB34E76F-231C-4E66-B5CB-113AFCE7A20F@oracle.com>
References: <20190617175658.135869-1-liran.alon@oracle.com>
 <20190617175658.135869-7-liran.alon@oracle.com>
 <20190618085539.GB2850@work-vm>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180123
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 18 Jun 2019, at 11:55, Dr. David Alan Gilbert <dgilbert@redhat.com> =
wrote:
>=20
> * Liran Alon (liran.alon@oracle.com) wrote:
>> Reviewed-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
>> Reviewed-by: Maran Wilson <maran.wilson@oracle.com>
>> Signed-off-by: Liran Alon <liran.alon@oracle.com>
>> ---
>> include/migration/vmstate.h | 18 ++++++++++++++++++
>> 1 file changed, 18 insertions(+)
>>=20
>> diff --git a/include/migration/vmstate.h =
b/include/migration/vmstate.h
>> index 9224370ed59a..a85424fb0483 100644
>> --- a/include/migration/vmstate.h
>> +++ b/include/migration/vmstate.h
>> @@ -797,6 +797,15 @@ extern const VMStateInfo vmstate_info_qtailq;
>> #define VMSTATE_UINT64_V(_f, _s, _v)                                  =
\
>>     VMSTATE_SINGLE(_f, _s, _v, vmstate_info_uint64, uint64_t)
>=20
> A comment here stating they're for Linux kernel types would be nice.

I didn=E2=80=99t want to state this because in theory these types can be =
used not in kernel context=E2=80=A6
I thought commit message is sufficient. I think comments in code should =
be made to clarify
things. But to justify existence I think commit message should be used.
But if you insist, I have no strong objection of adding such comment.

>=20
>> +#define VMSTATE_U8_V(_f, _s, _v)                                   \
>> +    VMSTATE_SINGLE(_f, _s, _v, vmstate_info_uint8, __u8)
>> +#define VMSTATE_U16_V(_f, _s, _v)                                  \
>> +    VMSTATE_SINGLE(_f, _s, _v, vmstate_info_uint16, __u16)
>> +#define VMSTATE_U32_V(_f, _s, _v)                                  \
>> +    VMSTATE_SINGLE(_f, _s, _v, vmstate_info_uint32, __u32)
>> +#define VMSTATE_U64_V(_f, _s, _v)                                  \
>> +    VMSTATE_SINGLE(_f, _s, _v, vmstate_info_uint64, __u64)
>> +
>=20
> Have you checked that builds OK on a non-Linux system?

Hmm that=E2=80=99s a good point. No. :P

-Liran

>=20
> Dave
>=20
>> #define VMSTATE_BOOL(_f, _s)                                          =
\
>>     VMSTATE_BOOL_V(_f, _s, 0)
>>=20
>> @@ -818,6 +827,15 @@ extern const VMStateInfo vmstate_info_qtailq;
>> #define VMSTATE_UINT64(_f, _s)                                        =
\
>>     VMSTATE_UINT64_V(_f, _s, 0)
>>=20
>> +#define VMSTATE_U8(_f, _s)                                         \
>> +    VMSTATE_U8_V(_f, _s, 0)
>> +#define VMSTATE_U16(_f, _s)                                        \
>> +    VMSTATE_U16_V(_f, _s, 0)
>> +#define VMSTATE_U32(_f, _s)                                        \
>> +    VMSTATE_U32_V(_f, _s, 0)
>> +#define VMSTATE_U64(_f, _s)                                        \
>> +    VMSTATE_U64_V(_f, _s, 0)
>> +
>> #define VMSTATE_UINT8_EQUAL(_f, _s, _err_hint)                        =
\
>>     VMSTATE_SINGLE_FULL(_f, _s, 0, 0,                                 =
\
>>                         vmstate_info_uint8_equal, uint8_t, _err_hint)
>> --=20
>> 2.20.1
>>=20
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

