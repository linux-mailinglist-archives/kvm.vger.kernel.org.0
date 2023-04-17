Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C7B6E41CD
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 09:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbjDQH6F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 03:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjDQH5g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 03:57:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1913C10;
        Mon, 17 Apr 2023 00:57:18 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33H7FN2b011504;
        Mon, 17 Apr 2023 07:57:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : to : subject : cc : message-id : date; s=pp1;
 bh=T5FZUthH1Gz1fO5fi4FamQlVotW7V7NzGISS4UHkRR4=;
 b=arl87F//XafdN5tVoIEumZ98Mp/ZgkneLDIlzWvOsrLM+b3IDD+YuWcH34aFS+ZwNY78
 FVPc66AK/972jICkMi/oKVve1hHS+dAcP902xAxq5Om2CuiRV6qUWsKE4UZXQioNqpvb
 XAXrCsSu0oVnp09KAZZVrSKaH/iSVSi2w8kCsBnd0ry6hgVOkh0FgDIS5w4LiWANM4SP
 rOHhmIhy538o+/VpMx6EEy2wDcW6z8c5SU9hybRNk5mZh41QBuGHbQu/azozogaNdozD
 8PWFSsn+pmew8QUL/DL1OxsCRBNumKRs0jMz/TuY8BHFVt8Xc6xedz0S5tqqJeqaFZlI Xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q0e6abut7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Apr 2023 07:57:17 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33H7uRHT020876;
        Mon, 17 Apr 2023 07:57:17 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q0e6abusj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Apr 2023 07:57:17 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33GIsskX002135;
        Mon, 17 Apr 2023 07:57:14 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3pykj6h5ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Apr 2023 07:57:14 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33H7v4M712649094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Apr 2023 07:57:04 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96E8120043;
        Mon, 17 Apr 2023 07:57:04 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7271D20040;
        Mon, 17 Apr 2023 07:57:04 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.0.19])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 17 Apr 2023 07:57:04 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230405123508.854034-1-nsg@linux.ibm.com>
References: <20230405123508.854034-1-nsg@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v1] s390x: Improve stack traces that contain an interrupt frame
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Message-ID: <168171822413.10491.11548053616048775653@t14-nrb>
User-Agent: alot/0.8.1
Date:   Mon, 17 Apr 2023 09:57:04 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Fk4XNGymFNQG-zn8KLkiuSVU3U6EKTAM
X-Proofpoint-GUID: gJlqfntp9iTGFJnC6o0qSTP6mgWBVqdq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-17_04,2023-04-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 clxscore=1015 impostorscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=785 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304170063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nina Schoetterl-Glausch (2023-04-05 14:35:08)
> When we encounter an unexpected interrupt we print a stack trace.
> While we can identify the interrupting instruction via the old psw,
> we don't really have a way to identify callers further up the stack,
> since we rely on the s390x elf abi calling convention to perform the
> backtrace. An interrupt is not a call, so there are no guarantees about
> the contents of the stack and return address registers.
> If we get lucky their content is as we need it or valid for a previous
> callee in which case we print one wrong caller and then proceed with the
> correct ones.

I did not think too much about it, so it might not work, but how about a
seperate interrupt stack?

Then, we could print the interrupt stack trace (which should be correct) an=
d -
with a warning as you suggest - the maybe incorrect regular stack trace.
