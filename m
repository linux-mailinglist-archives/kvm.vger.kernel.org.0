Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F3B6D3580
	for <lists+kvm@lfdr.de>; Sun,  2 Apr 2023 06:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjDBEpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Apr 2023 00:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDBEo7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Apr 2023 00:44:59 -0400
X-Greylist: delayed 11705 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 01 Apr 2023 21:44:54 PDT
Received: from smtp-out-webmail.u-picardie.fr (smtp-out-webmail.u-picardie.fr [195.83.152.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4B31C1DF;
        Sat,  1 Apr 2023 21:44:54 -0700 (PDT)
Received: from passoire-02.vm.u-picardie.fr (passoire-02.vm.u-picardie.fr [10.0.132.142])
        by smtp-out-webmail.u-picardie.fr (Postfix) with ESMTP id 4PpxK31w2Jz48XL;
        Sun,  2 Apr 2023 03:29:43 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at u-picardie.fr
Received: from smtp.u-picardie.fr ([10.0.132.224])
        by passoire-02.vm.u-picardie.fr (passoire-02.vm.u-picardie.fr [10.0.132.142]) (amavisd-new, port 10048)
        with LMTP id v5IjRJMW6GNN; Sun,  2 Apr 2023 03:29:35 +0200 (CEST)
Received: from horde-ext-05 (horde-ext-05.vm.u-picardie.fr [10.0.132.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: g21701498)
        by smtp.u-picardie.fr (Postfix) with ESMTPSA id 4PpxJs4gVvzH7C;
        Sun,  2 Apr 2023 03:29:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=u-picardie.fr;
        s=smtp; t=1680398975; h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=1Q4fsvgrk8Zeu3qzhzVcfoERSl56J1ECCxqTlujNu7c=;
        b=rb60F8FDMBL0Fe0Ixt4XeNl6vkXcu8waJFBFfRoh+tVPo0bgaPzCH69IyhESdRXV9alQUh
        qe114MyIQV0gBjcovxBrX1mYvAo1T0Xvro6xAwiyOjui82oSc80vY1iaaly/nXAJtb5W6z
        wYV9YCu5R/BJAildKYXBUMxrqCVDBnO8uNwgLaFvBBLBfAHr1kb29wDLFBWHg9e9xU9sqd
        8QBoisg1JtS7f+9sJj6OD/KNwjAXj7OVwTuPZFiAdeyhydgs8uVCIioZniendGBReTgTal
        OyfkSmNdAokQPxLfchjXrWaPooROeVNVTpNfh+UkyscQNSh288bGHACYu+2TCw==
Received: from unn-84-17-43-249.cdn77.com (unn-84-17-43-249.cdn77.com
 [84.17.43.249]) by webmail.etud.u-picardie.fr (Horde Framework) with HTTP;
 Sun, 02 Apr 2023 03:29:33 +0200
Date:   Sun, 02 Apr 2023 03:29:33 +0200
Message-ID: <20230402032933.Horde.OlYyVllhzrLzG5Y0oAP9WlN@webmail.etud.u-picardie.fr>
From:   St Thomas Hospital UK <guillaume.gobeaut@etud.u-picardie.fr>
Subject: Job Offer
Reply-to: recruitment@gstt-nhs-co-uk.com
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: -
Authentication-Results: smtp.u-picardie.fr;
        auth=pass smtp.auth=g21701498 smtp.mailfrom=guillaume.gobeaut@etud.u-picardie.fr
X-Rspamd-Server: passoire-04
X-Rspamd-Queue-Id: 4PpxJs4gVvzH7C
X-Spamd-Result: default: False [-1.10 / 1000.00];
        BAYES_HAM(-3.00)[100.00%];
        MISSING_TO(2.00)[];
        MIME_GOOD(-0.10)[text/plain];
        DKIM_SIGNED(0.00)[u-picardie.fr:s=smtp];
        NEURAL_HAM(-0.00)[-0.993];
        MIME_TRACE(0.00)[0:+];
        FROM_EQ_ENVFROM(0.00)[];
        RCVD_TLS_LAST(0.00)[];
        MID_RHS_MATCH_FROMTLD(0.00)[];
        R_RATELIMIT(0.00)[user(RLgcurcyohztxw7y),from(RL3etwgbhaz7x7jfbbsxwirdp8),user(RLwgotuqu5wsyzzj)];
        REPLYTO_DOM_NEQ_FROM_DOM(0.00)[];
        RCVD_VIA_SMTP_AUTH(0.00)[];
        HAS_REPLYTO(0.00)[recruitment@gstt-nhs-co-uk.com];
        RCVD_COUNT_TWO(0.00)[2];
        FROM_HAS_DN(0.00)[];
        TAGGED_RCPT(0.00)[];
        FREEMAIL_ENVRCPT(0.00)[gmail.com,inwind.it,comcast.net,yahoo.com,protonmail.com,hotmail.com,gmx.at,hotmail.co.uk,wp.pl,163.com,tiscali.it,outlook.com];
        ARC_NA(0.00)[]
X-Spam-Status: No, score=3.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,MISSING_HEADERS,REPLYTO_WITHOUT_TO_CC,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



    St. Thomas' Hospital UK
    REF: HR/MED-004/06923

St. Thomas' Hospital UK is a large NHS teaching hospital in Central  
London, England. It is one of the institutions that compose the King's  
Health Partners, an academic health science Center. Administratively  
part of the Guy's and St Thomas' NHS Foundation Trust, together with  
Guy's Hospital and King's College Hospital, it provides the location  
of the King's College London GKT School of Medical Education.

It is ranked amongst the best Ten (10) hospitals in the United Kingdom  
with 840 beds. The hospital has provided healthcare freely or under  
charitable auspices since the 12th century. It is one of London's most  
famous hospitals, associated with names such as Sir Astley Cooper,  
William Cheselden, Florence Nightingale, Linda Richards, Edmund  
Montgomery, Agnes Elizabeth Jones and Sir Harold Ridley. It is a  
prominent London landmark – largely due to its location on the  
opposite bank of the River Thames to the Houses of Parliament.

The largest not-for-profit health system in the world, we provide high  
quality, personalized and compassionate care to our patients through  
our dedication to safety, rigorous self-assessment, performance  
improvement, corporate integrity and health service management. We are  
committed to being the per-eminent provider of acute inpatient and  
outpatient health care services.

DESCRIPTION: Following the COVID-19 outbreak, expansion and  
development in our hospital, we are currently recruiting and employing  
the services of Medical Professionals  (Specialists, Consultants,  
General Practitioners) with relevant experiences to fill in the  
following below vacancies in our health care facility in the United  
Kingdom.



AREAS OF VACANCIES:

StH1. ALLERGY & IMMUNOLOGY StH2. ANAESTHESIOLOGY StH3. ANGIOLOGY StH4.  
ANTHROPOSOPHIC MEDICINE StH5. BREAST SURGERY  StH6. CARDIOLOGY StH7.  
CRANIOSACRAL PRACTITIONER / THERAPIST StH8. CARDIOTHORACIC SURGERY  
StH9. CARDIAC SURGERY

StH10. CRITICAL CARE MEDICINE StH11. DENTISTS StH12. DENTAL SURGEON  
StH13. DERMATOLOGY StH14. ENDOCRINOLOGY

StH15. EMERGENCY MEDICINE StH16. GASTROENTEROLOGY StH17. GENERAL  
SURGERY StH18. GENERAL PAEDIATRICS  StH19. GENERAL MEDICINE  StH20.  
HEMATOLOGY StH21. HYPERTENSION SPECIALIST StH22. INTERNAL MEDICINE  
StH23. INFECTOLOGY StH24. MORPHOLOGY StH25. NEPHROLOGY  StH26.  
NEUROSURGERY StH27. NEONATOLOGY StH28. ORTHOPAEDICS StH29. ORTHOPAEDIC  
SURGERY StH30. OTORHINOLARYNGOLOGY  StH31. ORTHODONTIST StH32.  
OCCUPATIONAL MEDICINE StH33. ORAL AND MAXILLOFACIAL SURGERY StH34.  
PATHOLOGY

StH35. PLASTIC & RECONSTRUCTIVE SURGERY StH36. PNEUMOLOGY StH37.   
PAEDIATRIC SURGEON  StH38.  PSYCHOLOGIST StH39.  PHYSIOTHERAPY  StH40.  
PEDIATRICS StH41. PUBLIC HEALTH  StH42. RADIOLOGY StH43. RHEUMATOLOGY  
StH44. REHABILITATION MEDICINE StH45. RESPIRATORY MEDICINE  StH46.  
THORACIC SURGERY  StH47. TRAUMATOLOGY StH48. TRICHOLOGIST StH49. UROLOGY



JOB LOCATION: London, United Kingdom

JOB COMMENCEMENT: 2023

EMPLOYMENT TYPE: Contract / Full-time

EMPLOYMENT BENEFITS:



Excellent Salary and Overtime Bonus, Health/life Insurance, Relocation  
expenses, Research and Educational assistance, Medical, Optical and  
Dental Care, Family/Single housing accommodation, 24/7 Official  
Vehicle, Scholarship for employee's dependent within UK schools.

Interested applicants are to send a detailed resume via email  
attachment along with medical graduation certificate(s) to:   
recruitment@gstt-nhs-co-uk.com

NOTE: APPLICATION IS OPEN TO INTERESTED PERSONS FROM ALL INTERNATIONAL  
LOCATIONS, ALL SUCCESSFUL APPLICANTS IN OUR RECRUITMENT PROCESS MUST  
BE WILLING TO RELOCATE TO THE UK FOR WORK.

Coronavirus (COVID-19)- Stay at home if you feel unwell. If you have a  
fever, cough and difficulty breathing, seek medical attention and  
call-in advance. Follow the directions of your local health authority.  
Source: World Health Organization



Sincerely,



Agnes Cardella
Medical Recruitment Assistant



St. Thomas' Hospital
Guy's & St. Thomas NHS Foundation Trust
London, United Kingdom

Tel:  +447 452 117 852
Fax: +447 6785 90456

St Thomas' Hospital UK incorporated in England, UK (Reg. No: 06160266)  
having its registered address at Westminster Bridge Rd, London SE1  
7EH, England.


