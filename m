Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623972FBA53
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 15:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404978AbhASOvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 09:51:36 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4528 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732263AbhASKjA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 05:39:00 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10JAWTAh136936;
        Tue, 19 Jan 2021 05:38:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type; s=pp1; bh=6AZXLusPpMXUi+ubbqboF/s0/MbSwdFs00HWqDMUeIs=;
 b=XWykHuIPzka+CdIwZ6KbTImoTY9Ffr2tMvV6rhHBaCjw4rVVGBtBzMGLoifvhRgYT1zh
 8/4y3i9vtnRb8PVhDDLbH+POAr2O/tDKju6mDWb8XDkyN20NV5wcaD0u16ojMnNBRfqN
 4TL8QOhUzNMlIGGWfiXP/hx1vFxDLTtCA98Xddoyp92y120OyQ5e35HtgCQw3NQAcqOx
 ZkXlFWj8EUcmw9ZV0d6CTvKiCKcZ2cQVa+8nG22/edD6xnUqX/27s8suNsfNHCERHVJl
 QJt51gEMbJxB9xLfy3Ezpw0D2S8j3z/ixUyAAS8iGvzkuvGk3FplyNWBUpZDtgtEk7Bj /g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 365wht8gjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 05:38:17 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10JAWlN2138140;
        Tue, 19 Jan 2021 05:38:17 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 365wht8gh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 05:38:16 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10JAbtkf003224;
        Tue, 19 Jan 2021 10:38:15 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 363t0y9fqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 10:38:14 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10JAc6PK19988940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 10:38:06 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E81EEAE058;
        Tue, 19 Jan 2021 10:38:11 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1461AE051;
        Tue, 19 Jan 2021 10:38:10 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.154.17])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jan 2021 10:38:10 +0000 (GMT)
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, gor@linux.ibm.com,
        mihajlov@linux.ibm.com
References: <20210119100402.84734-1-frankja@linux.ibm.com>
 <20210119100402.84734-3-frankja@linux.ibm.com>
 <3e1978c6-4462-1de6-e1aa-e664ffa633c1@de.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 2/2] s390: mm: Fix secure storage access exception
 handling
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
Message-ID: <4de19c74-65dc-5a29-76c7-99c600012fdf@linux.ibm.com>
Date:   Tue, 19 Jan 2021 11:38:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <3e1978c6-4462-1de6-e1aa-e664ffa633c1@de.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uNg3fdnfVdrte67zFburezChLKBSZGmkH"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_02:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 bulkscore=0 impostorscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uNg3fdnfVdrte67zFburezChLKBSZGmkH
Content-Type: multipart/mixed; boundary="FBy55sg7hWK1ojlw3ngKTWbPIoaPsz3KO";
 protected-headers="v1"
From: Janosch Frank <frankja@linux.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>,
 linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
 imbrenda@linux.ibm.com, cohuck@redhat.com, linux-s390@vger.kernel.org,
 gor@linux.ibm.com, mihajlov@linux.ibm.com
Message-ID: <4de19c74-65dc-5a29-76c7-99c600012fdf@linux.ibm.com>
Subject: Re: [PATCH 2/2] s390: mm: Fix secure storage access exception
 handling
References: <20210119100402.84734-1-frankja@linux.ibm.com>
 <20210119100402.84734-3-frankja@linux.ibm.com>
 <3e1978c6-4462-1de6-e1aa-e664ffa633c1@de.ibm.com>
In-Reply-To: <3e1978c6-4462-1de6-e1aa-e664ffa633c1@de.ibm.com>

--FBy55sg7hWK1ojlw3ngKTWbPIoaPsz3KO
Content-Type: multipart/mixed;
 boundary="------------32CDE7AFDD3E53275B0DC596"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------32CDE7AFDD3E53275B0DC596
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 1/19/21 11:25 AM, Christian Borntraeger wrote:
>=20
>=20
> On 19.01.21 11:04, Janosch Frank wrote:
>> Turns out that the bit 61 in the TEID is not always 1 and if that's
>> the case the address space ID and the address are
>> unpredictable. Without an address and it's address space ID we can't
>> export memory and hence we can only send a SIGSEGV to the process or
>> panic the kernel depending on who caused the exception.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Fixes: 084ea4d611a3d ("s390/mm: add (non)secure page access exceptions=
 handlers")
>> Cc: stable@vger.kernel.org
>=20
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

Thanks!

>=20
> some small things to consider (or to reject)
>=20
>> ---
>>  arch/s390/mm/fault.c | 14 ++++++++++++++
>>  1 file changed, 14 insertions(+)
>>
>> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
>> index e30c7c781172..5442937e5b4b 100644
>> --- a/arch/s390/mm/fault.c
>> +++ b/arch/s390/mm/fault.c
>> @@ -791,6 +791,20 @@ void do_secure_storage_access(struct pt_regs *reg=
s)
>>  	struct page *page;
>>  	int rc;
>> =20
>> +	/* There are cases where we don't have a TEID. */
>> +	if (!(regs->int_parm_long & 0x4)) {
>> +		/*
>> +		 * Userspace could for example try to execute secure
>> +		 * storage and trigger this. We should tell it that it
>> +		 * shouldn't do that.
>=20
> Maybe something like
> 		/*
> 		 * when this happens, userspace did something that it
> 		 * was not supposed to do, e.g. branching into secure
> 		 * secure memory. Trigger a segmentation fault.
>> +		 */

Sounds good

>> +		if (user_mode(regs)) {
>> +			send_sig(SIGSEGV, current, 0);
>> +			return;
>> +		} else
>> +			panic("Unexpected PGM 0x3d with TEID bit 61=3D0");
>=20
> use BUG instead of panic? That would kill this process, but it allows
> people to maybe save unaffected data.

That would make sense, will do

--------------32CDE7AFDD3E53275B0DC596
Content-Type: application/pgp-keys;
 name="OpenPGP_0xE354E6B8E238B9F8.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="OpenPGP_0xE354E6B8E238B9F8.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsFNBFubpD4BEADX0uhkRhkj2AVn7kI4IuPY3A8xKat0ihuPDXbynUC77mNox7yvK3X5QBO6q=
LqY
r+qrG3buymJJRD9xkp4mqgasHdB5WR9MhXWKH08EvtvAMkEJLnqxgbqf8td3pCQ2cEpv15mH4=
9iK
SmlTcJ+PvJpGZcq/jE42u9/0YFHhozm8GfQdb9SOI/wBSsOqcXcLTUeAvbdqSBZezuMRBivJQ=
QI1
esD9HuADmxdE7c4AeMlap9MvxvUtWk4ZJ/1Z3swMVCGzZb2Xg/9jZpLsyQzblDbbTlEeyBACe=
ED7
DYLZI3d0SFKeJZ1SUyMmSOcr9zeSh4S4h4w8xgDDGmeDVygBQZa1HaoLEsb8Y4avOYIgYDhgk=
Ch0
nol7XQ5i/yKLtnNThubAcxNyryw1xSstnKlxPRoxtqTsxMAiSekk0m3WJwvwd1s878HrQNK0o=
rWd
8BzzlSswzjNfQYLF466JOjHPWFOok9pzRs+ucrs6MUwDJj0ScITWU9Rxb04XyigY4XmZ8dywa=
xwi
2ZVTEg+MD+sPmRrTw+5F+sU83cUstuymF3w1GmyofgsUZ+/ldjToHnq21MNa1wx0lCEipCCyE=
/8K
9B9bg9pUwy5lfx7yORP3JuAUfCYb8DVSHWBPHKNjHTOLb2g2UT65AjZEQE95U2AY9iYm5usMq=
aWD
39pAHfhC09/7NQARAQABzSVKYW5vc2NoIEZyYW5rIDxmcmFua2phQGxpbnV4LmlibS5jb20+w=
sF3
BBMBCAAhBQJbm6Q+AhsjBQsJCAcCBhUICQoLAgQWAgMBAh4BAheAAAoJEONU5rjiOLn4p9gQA=
Ljk
dj5euJVI2nNT3/IAxAhQSmRhPEt0AmnCYnuTcHRWPujNr5kqgtyER9+EMQ0ZkX44JU2q7OWxT=
dSN
SAN/5Z7qmOR9JySvDOf4d3mSbMB5zxL9d8SbnSs1uW96H9ZBTlTQnmLfsiM9TetAjSrR8nUmj=
Ghe
2YUhJLR1v1LguME+YseTeXnLzIzqqpu311/eYiiIGcmaOjPCE+vFjcXL5oLnGUE73qSYiujwh=
fPC
CUK0850o1fUAYq5pCNBCoKT4OddZR+0itKc/cT6NwEDwdokeg0+rAhxb4Rv5oFO70lziBplEj=
Oxu
3dqgIKbHbjzaEXTb+mr7VI9O4tTdqrwJo2q9zLqqOfDBi7NDvZFLzaCewhbdEpDYVu6/WxprA=
Y94
hY3F4trTrQMHJKQENtF6ZTQc9fcT5I3gAmP+OEvDE5hcTALpWm6Z6SzxO7gEYCnF+qGXqp8sJ=
Vrw
eMubUscyLqHoqdZC2UG4LQ1OJ97nzDpIRe0g6oJ9ZIYHKmfw5jjwH6rASTld5MFWajWdNsqK1=
5k/
RZnHAGICKVIBOBsq26m4EsBlfCdt3b/6emuBjUXR1pyjHMz2awWzCq6/6OWs5eANZ0sdosNqd=
q2v
0ULYTazJz2rlCXV89qRa7ukkNwdBSZNEwsD4eEMicj1LSrqWDZMAALw50L4jxaMD7lPLjJbaw=
sFc
BBABCAAGBQJbm7i8AAoJELvpdr8mrl3SNBQQANp57g9R15FxBxvKpu2TvP9eZJl/CeVCb6ED8=
NZL
TUweQmm3mMfzmtkbuBU9BWJwR/dfqWnjvNA/8awXDA1dxLUEUC76y1P2ya5F1DGeB9PzmK3hq=
iez
jeN0irBJwMx2ZHT190NML8InRHry1pOvkFXQBrtgwzlyvgXsuU5Und/YesGPzYwVvb0rFIbjM=
ncm
FjuIIlrVnIH3iOcr9yG+4hLHcmKcPcOBStJi5KJT/5d13i4HRKj8j3Q2wyK/XPvqBl7CBTpUv=
grr
gZA856rkOVRCwy9v9q3+F7soRwGoaKoUxhWLJt/cCXoQbRCIc9UmNxq5a2pQLrCU3MOqZEPJB=
GT/
sYfsRlNsK4Shop/pubhvRKgYVFLH/Bc8gSvBKalIOkwQxUHyH6t0YXTOFcaIymRlt+XlyH8+r=
3rq
TLIVDzjxUur0OKU/1yjG7IIBzwoFAGxXzdkeSIJ3V2oXqH4WdM+BdawllDaq3t3qMu5ykjCBR=
yxU
M4S3SoSiYyz5u5mSlSFApJXGqz0HudIUCwoO3gLruHNnj8kT0ScwyPTqS4U3zA8qYYr9+2n5n=
gN4
ZuYxWCX7/GDhYAIysdj5N+MuXElIOZeO5EUp3nIjcuoTivWTj8i4lcS56tWcEdJyporJRbHRt=
VyV
5HNGWjZIlRi8z5YBkKD11bDYdFZAPskHFFN7wsFcBBMBAgAGBQJbm7WQAAoJEIZFfh8x4fgdb=
4YP
/3v5dXvrJTUFs+8WFrY6zCmbCPDgMOu+Yw96XMqJOfdUSFgJsr9KzREGjmV43Z5p90c9dR7hP=
9j9
gv6R2N/Gn6GHljrW9F381iF1vZ7zmPTRMhXOmc6rbpisp3EicImmV+aWO5pn9C9RT2hrC4E2a=
cbv
at8LlHGbxEsRQhRtlUnfAKNxGbxkaBx8nIyjmkiFCvYUdIfdQZ5Pz6ePmUWeXVzDZKK7UO+Ca=
M+U
IMhnm44m7ud6aSS7xQFLDJr+8i5BnST1GBaAR9gr0+wQfeO077heB62Wtxgg0jr9wWIOPiD2X=
XHD
v3g3K1362+PR+nxTmcBelVjFqQpRXnw4Kcs6fmhCslHV+ixXN59q9GjOZ/OueU0JZHqZ6AFZQ=
zYl
TQD9X2cUwVbtfyOd4U1VAOVJ1F4YjD0iOkzfT8iGiEHNwtqPyWPcBvEK4/ZTDNVMUKnJPkqMa=
RKY
Q2JCv3aROtFYOCfyVoVAB/hXXGfpPWhhy1wo6gYdYe6ywt28zxXDdA9j5CBaUiQX4u24xOHbF=
aE3
+9kWLfv1MgPH5Kq7DZM6WJ3SvcqclQdaUlgPQlFTg03b2akkOXwmyQQfjA5u9G7Rz0q+8WJ+d=
zRj
2z0xgd1kAU4zckGs61M6GGGCQYcLlo1JLqUPcfBGUyRDVA8T+Tv3SmwvEuO5H+FpSVqAIykAn=
YI1
wsFcBBABAgAGBQJbm8vmAAoJEBF7vIC1phx84ccQAJCm6ibzB4lubSlWZ1fCK0vmJdBu1nxjV=
LEj
lMXw+L0xmqB2aEi5QuzoYlctnvmsL6PG7em9XO89NgPKBMVeJPSIHJ2ASOJgPk0gUknz+luOG=
MmF
1JKjfC8nwaB2GDEbj0vd3bfgLb6vOavg7XzvFavuGO4U4mzlvs8Ts+uSPBXEHDJH97AMhm+Lw=
TsR
92/a9lM95zX3jUJQvm/d8kwx1zbwXy21noOH8XmS4a8y9OKOjK6d2cxbWQJ3uio9sMyIfvp9T=
jE8
mw4U5W8bOcGDGQJhLXOiosJNl/QWCLjWdBfyXNdVIY6NXBQfvax2j9IZmugnd3u4/mFZsM16I=
CnO
fl3ULbs+PFJq9WHvmlUvbMTuGFL88TIlnKWfogRWtlaSvGBNFMAg+QxI1MHWq8PH4BNe8TqQd=
Zps
kWiRc8mvbziH59zX5EsIN90eRSmcbP6n4kBFutwtNDV9j19ee52c0GljELlJ1Q2F55LqTr0sy=
4j2
sEfObfLjIjkGs4DvLjeWbSllVKXPJ4JTUJCFO680EHE0jZ9p/VLkYNp3GDmrOSe3b7NjAUag/=
uom
x5X324p1vNzpP6Thd25q87ZljkuWayXcPp5r/9nLd33ZlGWSx5/eaUBpDSqOfXNAJTuYoFMfD=
a3U
kkC5H38e8TvJbnikKEstdT/50GZq5u2hLKiWNGVEwsFcBBIBAgAGBQJbm7/VAAoJEA0vhuyXG=
x0A
Y3sP/2Be0rwSRICIji9aNduvMknMBUfSG4IVF5+3icvWDJUJbuu0diNYmIRCpn7uJuwBrnDeV=
aYB
CTU45q95swUiSBaWliK9G1NQtLVZjSQ6kFBN/c3/Gn1/eVasJz3/5dIn+wAHFbdWWHc2m2Cr1=
r+Z
r3z3D5g6CDiFlFTvDPo6ZHbaqu7o+2QEcwg3fA5/HRcw5KG8B+boVAFqhNHxTHYFe+WEj5f6m=
qu8
LovDjhotTPq+inybSj8FbDhIwA4xpj4TrSoO+K1z0Kuc0+p9xLmlRB3QEB1FZt4iFxTSeh6oD=
TwW
X8STUaH0FlZSQQvDi1EWWkVhMu6wH9fzDDKwyaE8nn95tLv4WtceCyiRBv76RGx/Q+ejmvrvy=
6R7
0hwjWfM0Sdly2KaErnSgtEbB01qx9NCs6OBm/GNhn2WwskXnQD2oS6hAMJNI38y/XkRw8Y9SQ=
4K1
uFVBqoB+KGm2YoLfTKbGCf5U3wStWBn8a2k1j2h1hjlmlx2mA8uPkqfZQqti+HByT65rQUzFK=
OwZ
hLGhKoV8xYl8n8uVdC/NVNQI6wNoi8tEBJt0ctYnb8YdVHfRDOV5gQUsd+lCIA2dZCHWqjnLA=
D6m
kt+Q8iaVsp5eFKBlGsBSGYBpD20QLw9lixwaDzag3AhV71438ia7rjuK+bfcT8hvdFcOhcmjk=
Ors
jSvqwsFcBBIBAgAGBQJbm8iIAAoJECIOw3kbKW7CFN8P/RQk+RC0NnpL/yFAP3sF07D8ttzZN=
V3F
08ofvstZjZ4Cvc5HBUwVGehrVQO/hIjzEw8VmMFh0jnquuyvD3/OekcEAQ7aSSeJtU5+4WCPK=
0Aw
sV6S08J2EFKaNArBFUOwRCRENUgSdkDYidwtxZ6nsf8kGh80Bjr23yWcDz7lgGSzbj8JmwmVp=
kRn
OE+gpwx/QK/LZPbuJzhrDtwK5TKRTg57ZTcoD5NZ6OmKg3lSCn9eh4q8m6V0l48Y79lrZ2+ZC=
384
PsQwByoKacl1CS50UzHsd4i+wsWIjs4cl0vyRkn0Qk69yEWgG0WZHoP7WfVjCrWfgw5gBxHoW=
/QA
2aZOdSGcCLsJ1ubHh+KP43CSTNLm/+8oA49guZmBI+YsTyt4vr6/vYDvrSIz73n22edbgUr8Q=
OXN
h+sHJ7LH1sWG3kdZ8GptPqZOr7lAoGsz3QlvlEPJwqwYodShQb7sZmfT2d63YL0whBkeHOj7y=
FQp
PQYa5YDrBGQv+FLrCquysFS0cw3NzeJzhzAnDy/uSn/v6tpzvw/Qc16gMrJU0OdzfgKjzjF0N=
4Yq
IFiTPdq+bTXrvV5009ElR0uCTFjK/JF4ZVB2tn+QUwy5Jq972X3TsCQfUJKNS/O6sVM+XvcR5=
zw7
ZyqWBOMI9OEzUhqolfH+Vq36shpPjNR821NhMxh4yvWhwsBcBBABCAAGBQJc7pIqAAoJEL4Y/=
M44
5LLlLoEH/19s1qwYjKU5FushYDRtQGMXBHHqbuWHXuFgQqw9Ro9aIQTg1J3JiP04hfTIipKkU=
k8W
T7bp8oPxhoGTGhunkLGeel4VGzqew6KNgUjR4aOHly1rqWARgY6Vn1Zs2pOQwhvMHFZKzNyTX=
X0l
R67kGYDRiOY4DOYoEiSpWa0LpaIjAXzvpXgzsp9cQ73yS9wBs1CaFlgi2IleI/HM64j4gQHYm=
Hva
JngficYZBislT+6TasOJYcbjMgXtIBi8dfvox6qA7weXaTLwIixJijpUofb1IiQVAJDNCYzdA=
7aI
IZ2wCoNpIeqw7a+567ecdbcTe+8XQOMzCpqYVYO6HEV0XtnCwXMEEgEIAB0WIQTzlzFsIQqcA=
xIF
ZpFGfI7ScWqT1wUCXO7vlwAKCRBGfI7ScWqT13aVD/9s3dQVKgqwEvTyZztMtwiWtTqb2AMjf=
5/g
1MW8XbN+pim6tP+63suWYitIUG8jL8gPXvLMhE28Tndk2RkalG7RjhDrT+aiJDKFL1KegwZTh=
QBQ
9xQvLP2wk+5i0p+F5ABMn2NivCD7XVw1pk1MUM1xDyVXLvqPT8sc35RORbuny7OeM50ZgaTS+=
5wv
8cQ4Nl8SmdyOX7teGVPUTNpJz3/QXL56dcF3p/CLtF9kcJw0biPSh+7WpDWFLe45yobY7N6Hs=
2ur
ptA9K0B+1f5WNdYdbvH0r4coPJ9FSVlSt9K4hUFR31eA/NLlWaq2NJfixTyC5QP8uykLh+ZgR=
U9K
NaGbXoSZ4EoYc3EQ56i4YAA0jJGhIdfbIY++GNs42xJuyqhYuJEKl/y7sCRxHqYGx4l+E+1gs=
V8E
43XKDIizjkgUOu1+Zcrqeo64gSqllCaT99/3v8uJFrZmWDDH1sYLnoxMgPfb+ZdVwu8t8YDlU=
zmc
F0vcbAIKFDLI9/sSFuaYW8zrfSZturGAX6geZAH5S/SLn4OnMC8oZrqZmJHu7Ty3zpey5Vajs=
l9K
gEcQ06D+YH/qF5IZA4E8SwQ1j7fD7LQu7ud4VuAaF1lKU5UeE+ZBv3TYdJ+5HevRbM26LbKox=
LpL
GR+y5qwPaMwgvYLb3wQsgBy88HFgF8J9cpicJBokrs7BTQRbm6Q+ARAAwHFE0alxf2mOdzkh+=
yMC
CvZRSsSJtCKBZDhIeyzH6exRs2j+wDa2XXCM4WYt/McjpHGhWPp6RhFr5KO65SAJ9CaQTuMd4=
X4Z
oQQ/1kmPC0CBUDTYxJt786zKO2/SWyQKkMX21EWNw6pdxlM3lkxvbmidNLvhBD5WPM3FUoQ5b=
SJe
Ty4odtHvMYE5zc8eXNddJUErtImb9pQBOgzPtmyUE7DEmIsCpcE7r/SyPQoZ6KOvrbDeeTasj=
MWK
iYBJZN1c5U10q9/q7UgsH7atnIpxE288XNV7oSF+qbv2ghpzX7hJDN+G+xtQ+gj8wzKqJDRW8=
qDu
g0Nfn1unOYHLV4P5WetNohJeAuK4HK9/hKX6D1FsynjPCV7+SqauGA8Yb24ra/A5vIK9/PlCh=
WSp
Vi5cIUOeq/8wFL+iyLJtdRphbNv3JoA9W6gUzRx3E1sFrUUy4Jp6iW1YrDCbmCbeCjT6qYU1r=
D2P
EhLW7nyJWB1zidpalMzkXk64ntrtKnErxgG0n3nPWqUxZdl5KP3Xaj3GTKSoQYl5mPLSc0j5N=
/hu
Larq+Ok2AJuaLorSbIAEetQru7Pjzbqv6Uyw4SvuvzY5nPeDRgXEQOKk7srBBhO/b2Fj9qCAF=
OBb
+oKmlh2eDBCNl06h/MIsMz3QkD2LEhNH11omLuzm3hK0+oi0k2RseK0AEQEAAcLBXwQYAQgAC=
QUC
W5ukPgIbDAAKCRDjVOa44ji5+AwxD/0bsnJFuuUmXDxuHDHzYFsWRfK1Y3lZf/TwX8tNSvEdI=
Wo1
ONG1rV0jIm8u49P3TI8/fYzei/gCRyb6y8+KmEc59mLPON1vkX14+tmXXuGDQROUi4ycHkQmz=
Fim
iS4+uPfX3LcU8nm/fgDC0EuMkUsB7gGS5gG+QMgltYAXE1mW/DjeQZlp0anhpiIAtRLwpx8vv=
mgZ
x059Jvs1fPQYUy01Gpd+bXI1BcJbgWN/UdrsfxzZQTtRmN2flmF4Qb6u6pGrU4S42kEppzqzI=
c6m
JnUoT9ZXhU1W811FCGL/xm8pzv2Ky9oGkKWj9WxFBIvJVAH1yWxFhnZxxZHIq8otPdhPP/Y/P=
QyY
OJpmajmru07VMY0TJQXCJYl5M0i1JPkLw+CytZFonrybHuJrXhQXZFh3z+AR//vA8WqUXBtVA=
IXk
p0kUOS4judGp5zge6Fxfr4CiGontkwX2cUDRgLN0UPm4Gg3IQqhZuWnYkj+fjk+DY5ClHhqQX=
v2k
ckEpXv0a6KU4AovOaY3v47mBJ9j/VAIJHwSazh70PWftkr2vBUXetTSS5AieCxbpkZ/cEJV9o=
nBW
4vFA1d3aNIVyUUWE1gsax7HDIZKxVi4WIjxeIqYV+1DXTlgUPdKqR8gMR5g2s3aNu4BI377IG=
DHb
3ipJxDkxG+aYcMVoIOwXCA6CX/VDAg=3D=3D
=3DR9cN
-----END PGP PUBLIC KEY BLOCK-----

--------------32CDE7AFDD3E53275B0DC596--

--FBy55sg7hWK1ojlw3ngKTWbPIoaPsz3KO--

--uNg3fdnfVdrte67zFburezChLKBSZGmkH
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAmAGtpIFAwAAAAAACgkQ41TmuOI4ufjy
WA/9FfCe81np3XXbe3/AvAaEAScV6aGxYQCOO981km2RKdZXCeFwinrNZMgtu4GhFwMFvVQCTy5E
2k/I9RZlDg7UvV27YjKBeW4bBFlk9ARAKzyLdtzsaoacQNcrFD9bwUSPW2MMO3n6Ifhe1je3vltm
86uCBq8fF0i9nZDcyaQqVo4I40fHbRz3cT9ThwPimkI66qaDkolvM1Vb1408w0fgiutwOzJu6tKs
+0/ZgonP5rk6ytddcxDO5Iz7509ckuGUiq/y0LkIPEmqP/ku1uxDP/fmgZ4hd+CVPmE6s8YCwAVd
hPIM94mrL5iEUooAb/669f1THWw+lw4hTVTxvxhlfFPtNlS9X0Dk4kKhJKVYDlkmkZ9MXEWLLcO7
2ahSu60e5IuCikZIxA+OgRNliFW6eOCPmgpi4dJ6ICuH8qej9CiJs/NMcfKF0/Tw0GlaHCPup/+U
omOjtKyGL4H5DAD+CqGigJOvIxMgiSrNXtkXsDQQjEAzz6YJ8FYkgdoh+n4E2aOVvm+Ls+AuIjxi
IQOLsXpzXYtSDYoqWEI5Bk6MmJ/IWJyK2toZ4jmf/J326CsARfzw81C9hcRS38h5WkLjN3ZbUIzV
gzg80rLa3r012PAgUpEfIcwrLgk7jzdcVf6sLimoQVdznvR54JL7sg+O3CRvtlNfRwB8gxYqAPxO
JpE=
=l6/W
-----END PGP SIGNATURE-----

--uNg3fdnfVdrte67zFburezChLKBSZGmkH--

