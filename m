Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C833F22CE
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 00:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236898AbhHSWL2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 18:11:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52066 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236988AbhHSWLO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Aug 2021 18:11:14 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17JM3UMq073374;
        Thu, 19 Aug 2021 18:10:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=s9oQOAi1oMeLWbk2SGSqnGs5buytPLYhHtKMOaBIb6A=;
 b=aM14whoIUSVhsMuqIdU5/2qLydGj9CPyPAK8w6xAZDsQ5OaRDPa4wMqll3fcLI2UJiQu
 64WyMSA3LGRpcWrurZbKkPMJNT8wb2tzl2ldhFOgIJRAiTBh6/n33Re5HAKYPyxz6Osx
 XeHG2HdHkZwiMmNpCJeqMg5J29fIEiBNw9MamP5NQoETjSQLxk3UGrjVT4zhpoDKAGHJ
 GCSxHEPtr4VksPfcTOjwMjNEWEPqPG/4+yHTvOuy9qqGeFcnpGb7QpXAZ55MaI0VqhZc
 RWOWYDzYTRmvhYDw0zaD3K6YwvjdSV3hKwBbaN33lZWJsmTXxnLUeecL7f3vuGP9nsjq Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ahk0yr6j4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 18:10:29 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17JM5UAk086447;
        Thu, 19 Aug 2021 18:10:28 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ahk0yr6hu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 18:10:28 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17JM3T03021949;
        Thu, 19 Aug 2021 22:10:27 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma01dal.us.ibm.com with ESMTP id 3ahu0ta8yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 22:10:27 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17JMAPCL34865546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Aug 2021 22:10:25 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7474878063;
        Thu, 19 Aug 2021 22:10:25 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A97567805E;
        Thu, 19 Aug 2021 22:10:22 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.160.128.138])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 19 Aug 2021 22:10:22 +0000 (GMT)
Message-ID: <d6eb8f7ff2d78296b5ba3a20d1dc9640f4bb8fa5.camel@linux.ibm.com>
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Tobin Feldman-Fitzthum <tobin@linux.ibm.com>,
        Steve Rutherford <srutherford@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        mst@redhat.com, tobin@ibm.com, richard.henderson@linaro.org,
        qemu-devel@nongnu.org, frankeh@us.ibm.com,
        dovmurik@linux.vnet.ibm.com
Date:   Thu, 19 Aug 2021 15:10:21 -0700
In-Reply-To: <YR5qka5aoJqlouhO@work-vm>
References: <cover.1629118207.git.ashish.kalra@amd.com>
         <CABayD+fyrcyPGg5TdXLr95AFkPFY+EeeNvY=NvQw_j3_igOd6Q@mail.gmail.com>
         <0fcfafde-a690-f53a-01fc-542054948bb2@redhat.com>
         <37796fd1-bbc2-f22c-b786-eb44f4d473b9@linux.ibm.com>
         <CABayD+evf56U4yT2V1TmEzaJjvV8gutUG5t8Ob2ifamruw5Qrg@mail.gmail.com>
         <458ba932-5150-8706-3958-caa4cc67c8e3@linux.ibm.com>
         <YR1ZvArdq4sKVyTJ@work-vm>
         <c1d8dbca-c6a9-58da-6f95-b33b74e0485a@linux.ibm.com>
         <YR4U11ssVUztsPyx@work-vm>
         <538733190532643cc19b6e30f0eda4dd1bc2a767.camel@linux.ibm.com>
         <YR5qka5aoJqlouhO@work-vm>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KeEQZ4f5mgVctXjPAxt3LZpPoLy6mHZn
X-Proofpoint-ORIG-GUID: 22mbp_qpwaXsEiVgdQPm2zFx57CDAg1s
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-19_07:2021-08-17,2021-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 impostorscore=0 suspectscore=0 clxscore=1015 malwarescore=0 adultscore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108190126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-08-19 at 15:28 +0100, Dr. David Alan Gilbert wrote:
> * James Bottomley (jejb@linux.ibm.com) wrote:
> > On Thu, 2021-08-19 at 09:22 +0100, Dr. David Alan Gilbert wrote:
[...]
> > > I think it really does have to cope with migration to a new
> > > version of host.
> > 
> > Well, you're thinking of OVMF as belonging to the host because of
> > the way it is supplied, but think about the way it works in
> > practice now, forgetting about confidential computing: OVMF is RAM
> > resident in ordinary guests, so when you migrate them, the whole of
> > OVMF (or at least what's left at runtime) goes with the migration,
> > thus it's not possible to change the guest OVMF by migration.  The
> > above is really just an extension of that principle, the only
> > difference for confidential computing being you have to have an
> > image of the current OVMF ROM in the target to seed migration.
> > 
> > Technically, the problem is we can't overwrite running code and
> > once the guest is re-sited to the target, the OVMF there has to
> > match exactly what was on the source for the RT to still
> > function.   Once the migration has run, the OVMF on the target must
> > be identical to what was on the source (including internally
> > allocated OVMF memory), and if we can't copy the MH code, we have
> > to rely on the target image providing this identical code and we
> > copy the rest.
> 
> I'm OK with the OVMF now being part of the guest image, and having to
> exist on both; it's a bit delicate though unless we have a way to
> check it (is there an attest of the destination happening here?)

There will be in the final version.  The attestations of the source and
target, being the hash of the OVMF (with the registers in the -ES
case), should be the same (modulo any firmware updates to the PSP,
whose firmware version is also hashed) to guarantee the OVMF is the
same on both sides.  We'll definitely take an action to get QEMU to
verify this ... made a lot easier now we have signed attestations ...

James


