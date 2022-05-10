Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06DD15218A0
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 15:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243363AbiEJNjc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 09:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244122AbiEJNgv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 09:36:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C622D625B;
        Tue, 10 May 2022 06:25:25 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24ACfalb019066;
        Tue, 10 May 2022 13:25:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=ZKuJhZQQuq6V768XjVGu5HUJKjxgMf1arVRizgrdFHc=;
 b=c83CGJpO1Sv58+hCMuhALQmgSVx1+e8j9aFrx5Lr7enTTbcc9jd+4Kf2rUtEf+pxKyn9
 /hblLio/NPJv2XscnQnfycCoovJ3ahhTTEz76JJsmdBp4EQwqvfsuiS+Eiz0XrZnBb5R
 39M+ckw9ZNlGN3WjnYu7Iz9V+fwkdxo8CIeddkoYOuif+41NbTlYCgpn9RPhh9DWlf33
 1GmFHllUbolJQ5DQASNA6tDgdoZx7NI++suh/bnCe4QKTQ2z0jT2di9+puTfBkFT18fX
 Prs+WgUN9EnpGcOMKDLeCIAcoqYbCUThDdjav4mqQL37yOFNy3R/TedvKQy2OeusWn9x Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fyncevehd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 13:25:15 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24ADFe1A019023;
        Tue, 10 May 2022 13:25:15 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fyncevegt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 13:25:15 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24ADDr0o013009;
        Tue, 10 May 2022 13:25:13 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3fwgd8u718-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 13:25:13 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24ADPAcx50856382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 May 2022 13:25:10 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4F14A4053;
        Tue, 10 May 2022 13:25:09 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4D2AA4040;
        Tue, 10 May 2022 13:25:09 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.29.124])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 May 2022 13:25:09 +0000 (GMT)
Message-ID: <d87472c1556d8503bdda9e1cec26b5d910468cbc.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: add cmm migration test
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com
Date:   Tue, 10 May 2022 15:25:09 +0200
In-Reply-To: <20220509155821.07279b39@p-imbrenda>
References: <20220509120805.437660-1-nrb@linux.ibm.com>
         <20220509120805.437660-3-nrb@linux.ibm.com>
         <20220509155821.07279b39@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MXsa_cEVXrShH0-A0vrRaLZHsV3_XbI-
X-Proofpoint-ORIG-GUID: RZRy3GDQrfpaDFJdhP6U2TlHpboJzeFT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-10_01,2022-05-10_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 mlxscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205100060
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-05-09 at 15:58 +0200, Claudio Imbrenda wrote:
> > +       for (i = 0; i < NUM_PAGES; i++) {
> > +               switch(i % 4) {
> > +                       case 0:
> > +                               essa(ESSA_SET_STABLE, (unsigned
> > long)pagebuf[i]);
> > +                       break;
> > +                       case 1:
> > +                               essa(ESSA_SET_UNUSED, (unsigned
> > long)pagebuf[i]);
> > +                       break;
> > +                       case 2:
> > +                               essa(ESSA_SET_VOLATILE, (unsigned
> > long)pagebuf[i]);
> > +                       break;
> > +                       case 3:
> > +                               essa(ESSA_SET_POT_VOLATILE,
> > (unsigned long)pagebuf[i]);
> > +                       break;
> 
> const int essa_commands[4] = {ESSA_SET_STABLE, ESSA_SET_UNUSED, ...
> 
> for (i = 0; i < NUM_PAGES; i++)
>         essa(essa_commands[i % 4], ...
> 
> I think it would look more compact and more readable

I like your idea a lot, but the compiler doesn't :-(:

/home/nrb/kvm-unit-tests/lib/asm/cmm.h: In function ‘main’:
/home/nrb/kvm-unit-tests/lib/asm/cmm.h:32:9: error: ‘asm’ operand 2
probably does not match constraints [-Werror]
   32 |         asm volatile(".insn
rrf,0xb9ab0000,%[extr_state],%[addr],%[new_state],0" \
      |         ^~~
/home/nrb/kvm-unit-tests/lib/asm/cmm.h:32:9: error: impossible
constraint in ‘asm’

To satify the "i" constraint, new_state needs to be a compile time
constant, which it won't be any more with your suggestion
unfortunately. 

We can do crazy stuff like this in cmm.h:

#define __essa(state) \
	asm volatile(".insn
rrf,0xb9ab0000,%[extr_state],%[addr],%[new_state],0" \
			: [extr_state] "=d" (extr_state) \
			: [addr] "a" (paddr), [new_state] "i"
(state));
static unsigned long essa(uint8_t state, unsigned long paddr)
{
	uint64_t extr_state = 0;

	switch(state) {
		case ESSA_SET_STABLE:
			__essa(ESSA_SET_STABLE);
		break;
		case ESSA_SET_UNUSED:
			__essa(ESSA_SET_UNUSED);
		break;
		case ESSA_SET_VOLATILE:
			__essa(ESSA_SET_VOLATILE);
		break;
		case ESSA_SET_POT_VOLATILE:
			__essa(ESSA_SET_POT_VOLATILE);
		break;
	}

	return (unsigned long)extr_state;
}

But that essentially just shifts the readability problem to a different
file. What do you think?

Or we make essa a marco, which doesn't sound like a particularily
attractive alternative either.
