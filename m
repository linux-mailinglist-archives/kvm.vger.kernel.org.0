Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1332574E8AC
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 10:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbjGKIHx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 04:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjGKIHw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 04:07:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FB61A8;
        Tue, 11 Jul 2023 01:07:51 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36B7lUov026716;
        Tue, 11 Jul 2023 08:07:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 in-reply-to : references : from : to : cc : subject : message-id : date :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Q/Z9iZkbSdrl2W+2/+DEOo+14gUnRcdgy1YqWt1pPLI=;
 b=JO3GoAyLZ88Yw7MFJvqNtq/emP7W6+DVo9pcfP1ST2ZmniMOWsIt0dvLpB8DROGjvCyW
 KHSjsz3jXkJp7G4oEf2J/t7wa/YCPulvJjhGQ7Ld79O3MxZ0cn0dg+Ed/WsHtX4hIwQH
 aGpHFbhuwou7/3JiOKOcgrc0ZiOLHzOImDDYwGSjbWboUj9XqDTZxgHcXalpOU3VTjyO
 TtsFxMx5xy/he9S5pYGMEaYWhNS4oefO0mE7+k21rGYY7/wbTbrlJ+tAvwNgX0b+SQtA
 wCmvmLyJmBURtzOyx3wq+E/MHmM2z0sCqEJdzgZvQMSjkhd0djj8ceagywilw/SNFrDa Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs309rkac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 08:07:51 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36B7pE4v004310;
        Tue, 11 Jul 2023 08:07:50 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs309rk8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 08:07:50 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36B7vkqb004141;
        Tue, 11 Jul 2023 08:07:48 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3rpye598cu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 08:07:48 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36B87i4834669150
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 08:07:44 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFEFE2004B;
        Tue, 11 Jul 2023 08:07:44 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8ECAC20040;
        Tue, 11 Jul 2023 08:07:44 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.68.148])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jul 2023 08:07:44 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <d52e4c34-55f0-56a5-1543-52fefb39e2a6@redhat.com>
References: <20230627082155.6375-1-pmorel@linux.ibm.com> <20230627082155.6375-3-pmorel@linux.ibm.com> <ffc48a06-52b2-fc65-e12d-58603d13b3e6@redhat.com> <168897816265.42553.541677592228445286@t14-nrb> <d52e4c34-55f0-56a5-1543-52fefb39e2a6@redhat.com>
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, kvm@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nsg@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v10 2/2] s390x: topology: Checking Configuration Topology Information
Message-ID: <168906286416.9488.17612605115280167157@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 11 Jul 2023 10:07:44 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0cc-zX8DdW6CAdI8UPatmffqzCdP6K5s
X-Proofpoint-GUID: UtdVO0aO5NAqSnalyIhGXg6HndFQrfmV
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_04,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 impostorscore=0
 bulkscore=0 spamscore=0 mlxlogscore=903 suspectscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2023-07-10 16:38:22)
> On 10/07/2023 10.36, Nico Boehr wrote:
> > Quoting Thomas Huth (2023-07-06 12:48:50)
> > [...]
> >> Does this patch series depend on some other patches that are not upstr=
eam
> >> yet? I just tried to run the test, but I'm only getting:
> >>
> >>    lib/s390x/sclp.c:122: assert failed: read_info
> >>
> >> Any ideas what could be wrong?
> >=20
> > Yep, as you guessed this depends on:
> > Fixing infinite loop on SCLP READ SCP INFO error
> > https://lore.kernel.org/all/20230601164537.31769-1-pmorel@linux.ibm.com/
>=20
> Ok, that fixes the assertion, but now I get a test failure:
>=20
> ABORT: READ_SCP_INFO failed
>=20
> What else could I be missing?

Argh, I forgot that you need this fixup to the patch:
https://lore.kernel.org/all/269afffb-2d56-3b2f-9d83-485d0d29fab5@linux.ibm.=
com/

If that doesn't work, let me know, so I can try and reproduce it here.
